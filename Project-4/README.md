## Integrating Jenkins with GitHub Webhooks

### Prerequisites:
- An Ubuntu Instance/VM
- Docker and Docker-Compose installed
- Java Development Kit (JDK)
- Access to Jenkins on port 8080 (Ensure port 8080 is enabled on EC2)

### Steps to Set Up Jenkins:

1. **Launch an Ubuntu Instance/VM:**
   - Launch an Ubuntu instance or VM.

2. **Install Docker:**
   ```
   sudo apt-get install docker.io
   ```

3. **Install Docker-Compose:**
   ```
   sudo apt-get install docker-compose
   ```

4. **Install Java (JDK):**
   - Install Java Development Kit (JDK) on the instance.

5. **Install Jenkins:**
   - Install Jenkins on the instance.

6. **Give Permissions to Users:**
   ```
   sudo usermod -aG docker $USER
   sudo usermod -aG docker jenkins
   ```
   - Reboot the server for changes to take effect.

7. **Check Jenkins is Running:**
   - Verify that Jenkins is running on port `https://<instance_ip>:8080`.

### Steps to Deploy Project:

1. **Create a Jenkins Job:**
   - Create a new Jenkins job.
   - Give a name for the project and select "Freestyle Project".

2. **Configure GitHub Project:**
   - Paste the GitHub project URL.
   - Select "Git" as the source code management.
   - Specify the branch name.
   - Choose "GitHub hook trigger for GITscm polling" under Build Triggers.

3. **Configure Webhook in GitHub:**
   - Go to the GitHub project settings.
   - Click on "Webhooks".
   - Add a new webhook and paste the Jenkins URL in "Payload URL" (`<jenkins_url>/github-webhook/`).

4. **Define Build Steps:**
   - Under Build, select "Execute Shell".
   - Enter the following commands:
   ```
   docker-compose down
   docker-compose up -d --no-deps --build web
   echo "Code Deployed successfully"
   ```

5. **Save Configuration:**
   - Save the Jenkins job configuration.

6. **Test Deployment:**
   - Go to the Jenkins project.
   - Make commits to trigger the Jenkins job.
   - Check the application on port `8000`.

### Conclusion:
Congratulations! You have successfully integrated Jenkins with GitHub webhooks and configured a Jenkins job to deploy your project automatically. Now, whenever changes are pushed to your GitHub repository, Jenkins will automatically trigger the deployment process.
