# Step 1: Create s3 bucket
# ----------------
aws s3api create-bucket --bucket tee-terraform-state-bucket --region us-east-1

# Step 2: Enable Versioning on the S3 Bucket
# ----------------------------------
aws s3api put-bucket-versioning --bucket tee-terraform-state-bucket --versioning-configuration Status=Enabled

# Step 3: Create a DynamoDB Table for State Locking

aws dynamodb create-table \
    --table-name terraform-lock-table \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
	
# Step 4: Configure the Terraform Backend	

cat <<EOF>backend.tf
terraform {
  backend "s3" {
    bucket         = "tee-terraform-state-bucket"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
EOF

# Step 5: Initialize the Terraform Backend
Now, initialize your Terraform configuration to use the new backend:

terraform init

# Step 6: Verify the Plan

terraform apply

# Step 7: Verify the Configuration
# Finally, verify that your Terraform setup is working correctly by applying your configuration:

terraform apply

# Step 2: For added security, enable server-side encryption on S3 bucket:
# ----------------------------------
aws s3api put-bucket-encryption --bucket tee-terraform-state-bucket --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'

