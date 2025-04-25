# Terraform-Based Pilot Light Disaster Recovery Solution

A robust disaster recovery solution using Terraform to implement the AWS Pilot Light DR strategy with automated failover capabilities.

## Overview

This project implements a Pilot Light disaster recovery architecture on AWS using Terraform. The Pilot Light approach keeps critical components of your infrastructure replicated but minimally running in a secondary AWS region to minimize costs while enabling rapid recovery during outages.

Unlike traditional DR solutions that require manual intervention, this implementation uses Route 53 health checks and load balancers to automatically detect failures and trigger failover to the disaster recovery region.

## Architecture

![Disaster_recovery_arch drawio (2)](https://github.com/user-attachments/assets/4d0dbe6a-9d52-4938-bcc4-25685c01b458)



The solution maintains:
- Primary infrastructure in the main AWS region
- Critical components (like database replicas) running in the DR region
- Non-critical resources defined but inactive in the DR region
- Automated health checks and failover mechanisms

## Key Features

- **Automatic Failover**: Uses Route 53 and load balancer health checks to detect outages and trigger failover without manual intervention
- **Cost Optimization**: Minimizes expenses by keeping most DR resources inactive until needed
- **Cross-Region Replication**: Maintains database replicas and storage synchronization across regions
- **Infrastructure as Code**: Entire solution defined in Terraform for consistency and repeatability
- **Security-Focused**: Includes proper IAM roles, security groups, and encryption configurations
- **Modular Design**: Organized into reusable Terraform modules for maintainability

## Prerequisites

- AWS account with permissions to create required resources
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of AWS services and Terraform

## Project Structure

```
terraform-pilot-light-dr/
├── main.tf                # Main Terraform configuration file
├── variables.tf           # Input variables for easy customization
├── outputs.tf             # Output values that show resource details
├── providers.tf           # AWS provider settings for multiple regions
├── modules/               # Organized components of the infrastructure
│   ├── ec2/               # Server configurations
│   ├── rds/               # Database settings
│   ├── s3/                # Storage buckets with cross-region replication
│   ├── lambda_failover/   # Serverless functions for failover automation
│   ├── acm/               # Certificate management
│   ├── acm_dr/            # DR region certificates
│   ├── alb/               # Load balancer configuration with health checks
│   ├── alb_dr/            # DR region load balancer
│   ├── autoscaling_group/ # Server scaling settings
│   ├── launch_template/   # Server startup configurations
│   ├── monitoring/        # Health checking and alerts
│   ├── rds_replica/       # Database copy in DR region
│   ├── route53/           # DNS settings for automatic failover
│   ├── secret_manager/    # Secure password storage
│   ├── security_group/    # Network security rules
│   └── vpc/               # Network configuration
├── primary/               # Primary region resources
└── scripts/               # Helper scripts
    ├── build/             # Build automation
    ├── venv/              # Python environment
    ├── .env               # Environment variables
    ├── install_docker.sh  # Docker installation script
    ├── lambda_function.py # Disaster recovery function code
    └── lambda.zip         # Packaged function code
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/terraform-pilot-light-dr.git
cd terraform-pilot-light-dr
```

### 2. Configure AWS Regions

Edit `variables.tf` to set your primary and DR regions:

```hcl
variable "primary_region" {
  description = "The primary AWS region"
  default     = "eu-west-1"
}

variable "dr_region" {
  description = "The disaster recovery AWS region"
  default     = "eu-central-1"
}
```

### 3. Configure Application Details

Update application-specific variables in `variables.tf`.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Plan and Apply

```bash
terraform plan
terraform apply
```

## Failover Process

This solution implements automated failover:

1. Route 53 health checks continually monitor the primary region endpoints
2. If health checks fail, Route 53 automatically routes traffic to the DR region
3. Load balancers in the DR region direct traffic to newly activated resources
4. Lambda functions trigger necessary DR promotion activities

## Testing Disaster Recovery

To test the DR capabilities without affecting production:

```bash
# Create a test environment with both regions
terraform workspace new test
terraform apply -var="environment=test"

# Simulate failure in primary region (see testing documentation for details)
# Observe automated failover to DR region
```

## Monitoring

The solution includes CloudWatch alarms and metrics to monitor:
- Health check status
- Replication lag
- Failover events
- Resource status in both regions

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## License

[MIT](LICENSE)

## Resources

- [AWS Disaster Recovery Architectures](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Well-Architected Framework - Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html)
