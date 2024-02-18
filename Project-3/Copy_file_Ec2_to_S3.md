**Title: How to Copy Files Between Amazon EC2 and Amazon S3**

**Introduction:**
This guide provides step-by-step instructions on how to copy files between an Amazon EC2 instance and an Amazon S3 bucket. By following these steps, you'll be able to seamlessly transfer files back and forth between your EC2 instance and S3 storage.

**Prerequisites:**
- An AWS account
- Access to the AWS Management Console
- Basic familiarity with the AWS Command Line Interface (CLI)

**Steps:**

**1. Create an EC2 Instance:**
   - Log in to the AWS Management Console.
   - Navigate to the EC2 service.
   - Click on "Launch Instance" and follow the prompts to create your EC2 instance. Ensure that you select an appropriate instance type and configure security groups to allow access.

**2. Create an S3 Bucket:**
   - Go to the S3 service in the AWS Management Console.
   - Click on "Create bucket" and follow the instructions to create a new S3 bucket. Choose a unique name and specify the region for your bucket.

**3. Create an IAM Role with S3 Full Access:**
   - Navigate to the IAM service in the AWS Management Console.
   - Click on "Roles" and then "Create role".
   - Choose the service that will use this role (EC2 in this case) and proceed.
   - Attach the policy "AmazonS3FullAccess" to the role.

**4. Modify the IAM Role of EC2:**
   - Go back to the EC2 service.
   - Select your instance and click on "Actions" > "Instance Settings" > "Attach/Replace IAM Role".
   - Choose the IAM role you created in step 3 and click "Apply".

**5. Copy from EC2 to S3:**
   - SSH into your EC2 instance.
   - Use the following command to copy a file from your EC2 instance to the S3 bucket:
     ```
     aws s3 cp file_name s3://<bucket_name>/targetFileName
     ```
     Replace `file_name` with the name of the file you want to copy and `<bucket_name>` with the name of your S3 bucket. Also, replace `targetFileName` with the desired name for the file in the S3 bucket.

**6. Copy from S3 to EC2:**
   - SSH into your EC2 instance.
   - Use the following command to copy a file from your S3 bucket to the EC2 instance:
     ```
     aws s3 cp s3://<bucket_name>/filename targetFileName
     ```
     Replace `<bucket_name>` with the name of your S3 bucket, `filename` with the name of the file you want to copy, and `targetFileName` with the desired name for the file on the EC2 instance.

**Conclusion:**
Congratulations! You've successfully learned how to copy files between an Amazon EC2 instance and an Amazon S3 bucket. By following these steps, you can efficiently transfer data between your EC2 environment and S3 storage.
