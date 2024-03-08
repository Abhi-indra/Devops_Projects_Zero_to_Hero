# Deployment of an ToDo application on AWS using AWS ECR and ECS Fargate

## Creating of Instances:
- Go to AWS console -> Search for EC2 and Luanch the instance.
- Login to the instance

## Install awscli and docker in the installation:
- Firstly, update the server 'sudo apt-get update'.
- Install awscli and docker
'''
sudo apt-get install awscli -y
sudo apt-get install docker.io -y
'''
- Give permission to the current user of docker 'sudo usermod -aG docker $USER'.
- Reboot the instance 'sudo init 6'.

## Create IAM user and Attach Permissions to it:
- Go to AWS console -> Go to IAM 
- Click on user -> click on Add user -> click next
- Click on attach policy -> select
'''
- AdministratorFullAccess
- Ec2ContainerRegistryfullAccess
- AmazonEcsfullAccess
- AWSAppRunnerServicePolicyForECR
- EC2InstanceProfileForImageBuilderECRcontainerBuild
- IAMUserChangePassword
- SecretManageReadWrite
'''
- Click on next
- Now, go to the crated user and generate access token
'''
- Go to Security Credentials -> Create Access token
- Save the CSV file.
'''

## Configure aws with Created Instance:
- SSH in Instance and type 'aws configure'.
- Provide details
'''
Access Key: 
Secret Ket:
default region:
Output format:
'''

## Create cluster in Elastic Container Service (ECS):
- Go to AWS console.
- Search ECS and click on it.
- Click on create cluster -> Give cluster name -> Select default VPC (If you have not created) -> Select AWS Fargate
- And, Create it.

## Create reository in Elastic Container Registry (ECR):
- Go to AWS console.
- Search ECR -> Get started 
- Click on Create Repository -> Click on public
- Give repo name -> OS (linux, windows and select *86, *86-64)
- Create Repository.

## Create Image using Docker & Push that image to Repo in ECR:
- Clone the github repo in Instance 'git clone github_URL'.
- Go Inside the repo folder
- Go to the aws console -> ECR -> click on view push command inside the created repo
1. Copy the first command and paste it.
2. Copy the second command and paste it.
3. Copy the third command and paste it.
4. Copy the fourth command and paste it.
- Now, go to ECR repo and check for images.
- Copy the image URL.

## Create Task Definition in ECS:
- Go to ECS -> Create Task Definition -> Give name -> Container name -> paste image URL 
- Container PORT: 8000
- Environment leave it default.
- Create it.

## RUN that task on ECS Cluster:
- Click on Deploy -> Run Task
- Select Cluster -> network: securitygroup(copy it and add the port 8000 in this security group)
- Click on next and create it.
- Check in Task (that is running or not)

## DONE Browse The application:
- copy public ip of instance and open with port 8000 'public_ip:8000'.

**Congratulations Project is completed successfully**