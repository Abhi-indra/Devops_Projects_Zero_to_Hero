**Title: Setting Up a Jenkins Pipeline with Docker Build & Push (Declarative) on AWS and Azure**

**Prerequisites:**

- An AWS account with an EC2 instance (Master Node)
- An Azure account with a Virtual Machine (Agent Node)
- Basic understanding of AWS, Azure, SSH, and terminal commands

**Steps:**

1. **Create Server Instances:**
   - **AWS EC2 Master Node:**
        - Launch an EC2 instance of your preferred size and operating system. Note down the public IP address.
	   - **Azure Virtual Machine (Agent Node):**
	    - Create an Azure VM with your desired configuration. Make sure to enable SSH access during VM creation. Note down the public IP address and username for the VM.

2. **Install Java on Both Servers:**
	- **On both EC2 and Azure VM:**
		- Connect to your servers using SSH. Refer to the official documentation for your chosen operating system on installing Java.

3. **Install Jenkins on Master Node:**
	- Follow the official Jenkins installation guide for your chosen operating system ([https://www.jenkins.io/doc/book/installing/linux/](https://www.jenkins.io/doc/book/installing/linux/)).

4. **Install Docker and Docker Compose on Agent Node:**
	- **On the Azure VM:**
		- Refer to the official Docker documentation for installation instructions specific to your VM's operating system ([https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)).
		- Install Docker Compose using commands like `sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -v$(docker-compose version --short) && sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose`.
	- **Grant Permissions:**
		- Run `sudo usermod -aG docker $USER` to add your current user to the `docker` group.
		- Restart the Azure VM for the changes to take effect.

5. **Configure Security Groups (Firewalls):**
	- **AWS EC2:**
		- In the AWS Management Console, navigate to the EC2 service.
		- Go to your security group and add an inbound rule allowing traffic on port 8080 (Jenkins UI) from your IP address or a specific CIDR range.
	- **Azure VM:**
		- In the Azure portal, go to your VM's settings.
		- Under "Network security group," allow inbound traffic on ports 8000 (Docker Compose) and 8080 (Jenkins UI) from your IP address or a CIDR range.

6. **Set Up Distributed Build (Master Node):**
		- In the Jenkins dashboard, navigate to "Manage Jenkins" -> "Configure Jenkins."
		- Under "Agent Nodes," click "Add Agent."
		- Choose "Permanent Agent" and fill in the details:
		- Node Name: Give it a descriptive name (e.g., dev-agent)
		- Remote Root Directory: Find this using `pwd` on your Azure VM.
		- Label: Use the same name as the Node Name (dev-agent).
		- Launch Method: Select "Launch agent via SSH."
		- Host: Enter the public IP address of your Azure VM.
		- Credentials: Choose "Jenkins" and provide the username and password you set during Azure VM creation.
		- ID: Use the same name as the Node Name (dev-agent).
		- Host Key: Select "Non-verifying strategy" (**Caution:** This is less secure for production environments. Use key-based authenticaton for improved security).
		- Click "Save" to create the agent connection.

7. **Install Plugins and Configure DockerHub Credentia**
	- **Install Environment Plugin:**
		- Go to "Manage Jenkins" -> "Manage Plugins" -> "Available Plugins."
		- Search for "Environment injector plugin" and install it along with any required dependencies.
		- Restart Jenkins for the plugin to take effect.
	- **Configure DockerHub Credentials:**
		- Create a personal access token on Docker Hub ([https://docs.docker.com/security/for-developers/access-tokens/](https://docs.docker.com/security/for-developers/access-tokens/)).
		- In Jenkins, go to "Manage Jenkins" -> "Manage Credentials" -> "System" -> "Global credentials (unrestricted)."
		- Click "Add Credentials."
		- Choose "Username/Password" and fill in the details:
		- Username: Your Docker Hub username.
		- Password: The access token you generated.
		- ID: Give it(DockerHub)

**8. Create the Jenkins Pipeline with GitHub Webhook Integration:**

   - **Create a New Job:**
        - In the Jenkins dashboard, click "Create Job."
	     - Give your job a descriptive name (e.g., docker-build-push).
	     - Select "Pipeline" as the job type and click "OK."

	- **Configure GitHub Hook Trigger:**
		- In the job configuration, under "Build Triggers," select "GitHub hook trigger for GITScm."
	- **On your Project Repository in GitHub:**
		- Go to "Settings" -> "Hooks" -> "Add webhook."
		- Enter your Jenkins server URL under "Payload URL" (e.g., `http://<your_master_node_ip>:8080/github-webhooks`).
		- Select "Send me everything" to trigger builds on all events.
		- Click "Add webhook" and verify the connection (green tick).

	- **Add Pipeline Script:**
		- Paste the pipeline script (Jenkinsfile) from your project repository's `project/project-2/n..p/` folder into the job's "Pipeline" section.
		- Edit the configuration as needed, including:
		- Replace placeholders like image name with the actual values from your project.
		- Update the DockerHub credentials ID to match the one you created in step 7.
		- Save the job configuration.

**9. Verify the Pipeline Execution:**

		- Push any changes to your project repository on GitHub.
		- If configured correctly, Jenkins should automatically trigger a build using your pipeline script.
		- The pipeline should:
				- Checkout your project code from GitHub.
				- Build the Docker image using the Dockerfile in your project.
				- Push the image to your Docker Hub repository using the credentials you configured.

- **Verify the Image on Docker Hub:**
		- Login to your Docker Hub account.
		- Go to your repository and check if the image has been successfully pushed.

- **Access Your Application (Optional):**
		- If your pipeline script deploys the application on the Azure VM using Docker Compose, you can access it using the following steps:
		- Find out the public IP address of your Azure VM.
		- Access the application URL using the format `http://<azure_vm_ip>:8000` (replace with the actual IP).


By following these steps and incorporating the best practices mentioned above, you can set up a robust and secure CI/CD pipeline using Jenkins, Docker, and GitHub for your project.
