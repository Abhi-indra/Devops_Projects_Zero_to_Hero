# Restrict-access-to-owner in S3 bucket

**Understanding the Goal**

Our objective is to ensure that only the owner (the IAM user who created the S3 bucket) has access to modify, view, or delete the bucket and its contents. This policy prevents unauthorized access to potentially sensitive data stored within the bucket.

**Steps to Implement Bucket Policy**

1. **Access AWS Management Console:** Log in to the AWS Management Console and navigate to the Amazon S3 service.
2. **Select Your Bucket:** From the list of buckets, click on the bucket for which you want to restrict access.
3. **Open Bucket Permissions:** Under the "Permissions" tab, click on the "Bucket Policy" section.
4. **Paste the Policy Code:** In the policy editor, paste the provided policy code, replacing `your-bucket-name` with the actual name of your S3 bucket.
5. **Review and Save:** Carefully review the policy code to ensure it aligns with your requirements. Once satisfied, click "Save" to apply the bucket policy.

**Explanation of the Provided Policy Code:**

```json
{
  "Version": "2012-10-17",  # Specifies the policy format version
  "Id": "RestrictBucketToIAMUsersOnly",  # Policy identifier for reference
  "Statement": [
    {
      "Sid": "AllowOwnerOnlyAccess",  # Statement identifier for clarity
      "Effect": "Deny",  # Action to be taken (Deny all by default)
      "Principal": "*",  # Applies to all users (including anonymous users)
      "Action": "s3:*",  # All S3 bucket actions are denied
      "Resource": [  # Resources (bucket and its objects) to which this applies
        "arn:aws:s3:::your-bucket-name/*",  # ARN for bucket contents
        "arn:aws:s3:::your-bucket-name"  # ARN for the bucket itself
      ],
      "Condition": {  # Exception clause for the owner
        "StringNotEquals": {  # Condition type (check for unequal string)
          "aws:PrincipalArn": "arn:aws:iam::AWS_ACCOUNT_ID:root"  # Principal ARN for root user
        }
      }
    }
  ]
}
```

- **Version:** Specifies the policy format version used (2012-10-17 in this case).
- **Id:** A unique identifier for this policy for easier referencing and management.
- **Statement:** An array that defines specific policy rules. Here, there's one statement.
  - **Sid:** A unique identifier for the statement within the policy.
  - **Effect:** Defines whether to allow or deny the specified actions (Deny in this case).
  - **Principal:** The entity the policy applies to (here, `*` for all users).
  - **Action:** The S3 actions to which the policy applies (all actions with `s3:*`).
  - **Resource:** The specific S3 resources targeted by the policy (both the bucket and its contents).
  - **Condition:** An exception clause that allows access if a certain condition is met (in this case, if the principal's ARN is not equal to the root user's ARN).

**Additional Considerations:**

- This policy restricts access to all users, including IAM users with different permissions within your account. If you need to grant specific users access to certain S3 objects within the bucket, you can create IAM policies for those users, allowing them to perform necessary actions on specific objects or prefixes within the bucket.
- For enhanced security, consider using least privilege principles. Grant IAM users only the minimum permissions they require to perform their tasks effectively.
- Regularly review and update your bucket policies as your security needs evolve.

By implementing this policy, you can effectively control access to your S3 bucket and safeguard confidential data.