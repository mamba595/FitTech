# CI/CD Pipeline

## Description
This CI/CD (Continuous Integration / Continuous Deployment) pipeline has allowed me to automate the execution of unit and integration tests, and the deployment of my app to the cloud, ensuring code quality, lack of vulnerabilities in the code and in the Docker image, and letting me iterate faster and find bugs and security issues that otherwise would have been harder and time consuming for me to detect.

I will explain each job of the pipeline and the reasoning behind it. For context, I used Github Actions for the CI/CD pipeline, which allowed me to run each job in a different Github Actions runner, which is a VM (Virtual Machine) that I don't need to manage, which is great.

I've learned so much about the whole production cycle of an app, and how quality controls and automated deployment reduces human error and time while enabling engineers to focus on bigger problems rather than getting stuck by small errors that are hard to find. Also, I've learned how to hide secrets from being embedded into production using Github Secrets. In Github Actions you can check the last runs of this pipeline and how much I had to debug to make this work.

## First Job: Test
Before talking about the first job, I want to mention that this pipeline runs when there's a git push or pull request to the branch main, or with a button in the Github Actions interface, which is very useful when the previous job failed for residual AWS resources from previous runs rather than any other error with the app.

Each job will have the same initial pattern, which will be read the code from the repository and install the dependencies necessary for the job, in this case Python dependencies because this job focuses on checking the quality of the code, and since the app is a FastAPI REST API, it needs Python. Also, each job uses the same operating system version for the CI/CD runner, ubuntu-22.04, to make sure the pipeline doesn't break by maintaining the same environment across jobs.

Each step from the job will use a Github Action, which is an already defined function simplifies the pipeline by reducing the amount of code to be written for each function needed.

This job will check the code for quality errors, like syntax errors, and security vulnerabilities in the app dependencies, and run unit tests for specific functions from the code that do not need a database connection. The unit tests are located in the tests/unit folder, with only one file.

## Second Job: Build and Push
This job only runs if the previous step was completed successfully and builds the Docker image, pushes it to the ECR (Elastic Container Registry), which is the AWS repository where you can upload your Docker images and pull them later when deploying an app and requesting the latest image for your containers in the cloud. It also detects vulnerabilities in the image, which seem infrequent and unnecessary because the previous step already check for the app dependencies, but a lot of security issues can be found in the Docker image that didn't appear in the previous step, being remote code execution an example.

The job passes to the next job the image digest, so that the image can be pulled from the ECR registry later on.

## Third Job: Integration Tests
The image is pulled from the ECR registry and is run with a PostgreSQL image, to simulate a real connection with the database, so that the app endpoints can be tested as if a testing tool like Insomnia or Postman was used.

The integration tests use pytest fixtures for registering and logging in with an specific user for the test session, since each endpoint from the app requires a token for authentication to be provided in the headers of the request. The GET and POST endpoints of onboarding, food-logs and workout-logs are tested with synthetic data to check if they work correctly and the REST API has no issues connecting with the database.

## Fourth Job: Terraform deployment
The image isn't directly pulled by the Github Actions runner, but provided as a variable for Terraform, along with Github Secrets variables, for Terraform to provide these secrets directly to the ECS tasks, without leaking them in production logs.

The app infrastructure is deployed in this final job, making sure it the ECS tasks have the latest Docker image of the app, which automated the deployment of the app if it passed all the previous quality and security controls. It also checks that the app is working by testing it doing a request to the ALB url for the /health endpoint, which responded with status "ok" (200) the last time I ran this pipeline.