<?php
require 'vendor/autoload.php';
use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;
function getDatabaseCredentials() {
    $secretName = "dr-project-secret-key-eu-west-1";  // Use the correct secret name
    $region = "eu-west-1";  // Ensure the region is correct
    try {
        $client = new SecretsManagerClient([
            'region' => $region,
            'version' => 'latest',
        ]);
        $result = $client->getSecretValue([
            'SecretId' => $secretName,
        ]);
        if (isset($result['SecretString'])) {
            // Decode the secret JSON
            $secrets = json_decode($result['SecretString'], true);
            // Print the actual credentials
            echo "Database Credentials:\n";
            echo "Host: " . ($secrets['host'] ?? 'N/A') . "\n";
            echo "Database: " . ($secrets['dbname'] ?? 'N/A') . "\n";
            echo "User: " . ($secrets['username'] ?? 'N/A') . "\n";
            echo "Password: " . ($secrets['password'] ?? 'N/A') . "\n";
            echo "Port: " . ($secrets['port'] ?? 'N/A') . "\n";
        } else {
            echo "No secret string found.";
        }
    } catch (AwsException $e) {
        echo "Secrets Manager Error: " . $e->getMessage();
    }
}
// Call the function to print credentials
getDatabaseCredentials();
?>