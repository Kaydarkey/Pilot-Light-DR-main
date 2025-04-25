import boto3 # type: ignore
import time
import json
import os

rds = boto3.client('rds')
secretsmanager = boto3.client('secretsmanager')
autoscaling = boto3.client('autoscaling')

replica_id = "postgres-db-replica"
asg_name = "dr-project-ec2-pilot-asg"
secret_name = "dr-project-secret-key-eu-central-1"

def is_already_promoted(db_instance):
    return not db_instance.get('ReadReplicaSourceDBInstanceIdentifier')

def lambda_handler(event, context):
    try:
        # Step 1: Describe DB to check status
        print("Checking replica status...")
        db_info = rds.describe_db_instances(DBInstanceIdentifier=replica_id)
        db_instance = db_info["DBInstances"][0]

        if is_already_promoted(db_instance):
            print("✅ Replica is already promoted and available.")
        else:
            print("Promoting replica...")
            try:
                rds.promote_read_replica(DBInstanceIdentifier=replica_id)
            except Exception as e:
                print(f"⚠️ Promotion might already be in progress or completed: {e}")

            print("⏳ Waiting for RDS promotion to complete...")
            waiter = rds.get_waiter('db_instance_available')
            waiter.wait(DBInstanceIdentifier=replica_id, WaiterConfig={'Delay': 120, 'MaxAttempts': 20})
            print("✅ Replica promoted successfully.")

        # Refresh DB info to get updated endpoint
        db_info = rds.describe_db_instances(DBInstanceIdentifier=replica_id)
        endpoint = db_info["DBInstances"][0]["Endpoint"]["Address"]
        print("Endpoint:", endpoint)

        # Step 2: Create/Update Secret
        secret_payload = {
            "username": os.getenv('DB_USERNAME'),
            "password": os.getenv('DB_PASSWORD'), 
            "host": endpoint,
            "port": int(os.getenv('DB_PORT', 5432)),
            "dbname": os.getenv('DB_NAME', 'file_server')
        }

        print("Creating or updating secret...")
        secretsmanager.update_secret(
            SecretId=secret_name,
            SecretString=json.dumps(secret_payload)
        )
        print(f"✅ Secret '{secret_name}' updated.")

        # Step 3: Scale ASG
        print("Scaling ASG...")
        autoscaling.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=1,
            MinSize=1
        )
        print("✅ ASG scaled up.")

        return {"status": "success", "message": "RDS promoted, secret created, ASG scaled."}

    except Exception as e:
        print("❌ Error:", str(e))
        return {"status": "error", "message": str(e)}
