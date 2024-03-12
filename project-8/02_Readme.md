# Host Static Website on S3 Bucket.

**Prerequisites:**

- An AWS account with an IAM user with appropriate permissions. You can create a free tier account if you don't have one already.
- A domain name registered with a domain registrar.
- Your static website files, ready to be uploaded to S3.

**Steps:**

1. **Create an S3 Bucket:**
   - Go to the AWS Management Console and navigate to the S3 service.
   - Click on "Create bucket."
   - Choose a unique bucket name that adheres to DNS naming conventions (lowercase letters, numbers, and hyphens). For best practices, consider including your domain name to create a memorable reference.
   - Select a region closest to your target audience for potentially faster website loading times.
   - Under "Block public access settings," **uncheck all boxes** to allow public access for website hosting. We'll configure specific permissions later for security.
   - Click "Create bucket."

2. **Upload Website Files:**
   - Open your newly created bucket.
   - Click on the "Upload" button.
   - Drag and drop your entire static website directory or select "Add files" to choose individual files.
   - Click "Next" and leave the default permissions (objects inherit bucket permissions).
   - Click "Next" again and leave the default settings for object properties.
   - Click "Upload" to upload your website files.

3. **Configure Static Website Hosting:**
   - In the bucket properties, navigate to the "Static website hosting" section.
   - Click "Edit."
   - Select "Use this bucket to host a website."
   - In the "Index document" field, enter the name of your main HTML file, typically "index.html." This is the file that will load first when someone visits your website.
   - The "Error document" field is optional. It specifies a custom error page to display if an error occurs while loading a resource.
   - Click "Save changes."

4. **Set Public Access Permissions:**
   - **Important:** By default, S3 buckets block all public access. To make your website publicly accessible, we need to grant specific permissions. However, it's essential to maintain security by following least privilege principles.
   - In the bucket properties, under "Permissions," navigate to "Bucket Policy."
   - Click "Edit bucket policy."
   - Paste the following policy code, replacing `your-bucket-name` with your actual bucket name:

   ```json
   {
     "Version": "2012-10-17",
     "Id": "PolicyForStaticWebsiteHosting",
     "Statement": [
       {
         "Sid": "AllowPublicReadAccess",
         "Effect": "Allow",
         "Principal": {
           "AWS": "*"
         },
         "Action": [
           "s3:GetObject"
         ],
         "Resource": [
           "arn:aws:s3:::your-bucket-name/*"
         ]
       }
     ]
   }
   ```

   - This policy grants read access (permission to view objects) to anyone (AWS principal "*").
   - It only allows the `s3:GetObject` action, restricting other actions.
   - The resource is limited to your bucket and its objects (`your-bucket-name/*`).

   - Click "Review Policy" to verify its correctness, then click "Activate" to apply the policy.

5. **Configure Your Domain Name:**

   - To make your website accessible at your domain name, you need to configure your domain registrar's DNS settings to point to your S3 bucket. This typically involves creating a record (often a "CNAME" or "A" record) that maps your domain name to the website endpoint of your S3 bucket.

   - The specific instructions will vary depending on your domain registrar. Refer to their documentation or support for guidance on setting up DNS records for static website hosting with S3.

   - Once you have configured your DNS records, it may take some time (usually up to 24 hours) for the changes to propagate globally.

**Testing Your Website:**

- After your DNS records have propagated, navigate to your domain name in a web browser to test your website. If everything is configured correctly, your static website should be live!

