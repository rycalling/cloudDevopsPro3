# cloudDevopsPro3: Coworking Space Microservice
This README serves as documentation to detail how  deployment process works and how we can deploy changes. it helps an experienced software developer to understand the technologies and tools in the build and deploy process as well as provide insight into how to release new builds. The Coworking service provides business analysts with basic analytics data on user activity in the coworking space service. 
## Prerequisites
Before deploying the Coworking Space Microservice, ensure that you have the following **tools and resources set up**:
- **Development Tools:** Python 3.6+, Docker CLI, kubectl, Helm, GitHub access.
- **AWS Resources:** AWS CLI, AWS CodeBuild, AWS ECR (Elastic Container Registry), Kubernetes Environment with AWS EKS (Elastic Kubernetes Service), AWS CloudWatch.

## Basic Deployment
1. **Database Setup:** set up the PostgreSQL database on Kubernetes cluster and populate it with data by running the following commands:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install sql-service bitnami/postgresql --set primary.persistence.enabled=false
export POSTGRES_PASSWORD=$(kubectl get secret --namespace default sql-service-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

export DB_USERNAME=myuser
export DB_PASSWORD=mypassword
export DB_HOST=127.0.0.1
export DB_PORT=5433
export DB_NAME=mydatabase
```
2. **Dockerization:** build and push `Dockerfile` for the Python application.
```
docker build -t myecr:0.1.0 .
docker tag myecr:<version> <ACCOUNT>.dkr.ecr.us-east-1.amazonaws.com/myecr:<version>
docker push <ACCOUNT>.dkr.ecr.us-east-1.amazonaws.com/myecr:<version>
```
3. **AWS CodeBuild Pipeline:** configure a build pipeline using AWS CodeBuild to build and push the Docker image into AWS ECR with `buildspec.yml` file defining building steps.
4. **EKS Deployment:** deploy changes to Kubernetes cluster with `kubectl apply -f deployment/` command. This will make the API available within the cluster.
5. **API Logs:** verify the deployment with `kubectl logs <POD_NAME>` or the corresponding logs in AWS CloudWatch.

## Deliverables
1. Postgres database with a Helm Chart.
2. Dockerfile for the Python application.
3. Build pipeline with AWS CodeBuild to build and push a Docker image into AWS ECR.
4. Screenshot of AWS CodeBuild pipeline for your project submission.
5. Screenshot of AWS ECR repository for the application's repository.
6. Service and deployment using Kubernetes configuration files to deploy the application.
7. All the Kubernetes config files used for deployment (ie YAML files).
  Screenshot of running the kubectl get svc command.
  Screenshot of kubectl get pods.
  Screenshot of kubectl describe svc <DATABASE_SERVICE_NAME>.
  Screenshot of kubectl describe deployment <SERVICE_NAME>.
8. AWS CloudWatch for application logs.
  Screenshot of AWS CloudWatch logs for the application.
Create a README.md file

## Further Release process
1. Commit your code changes to the GitHub repository.
2. Automatically trigger the AWS CodeBuild pipeline on GitHub `push` action to build and push a new Docker image to AWS ECR. Image is built and pushed with an `$CODEBUILD_BUILD_NUMBER` defined as an environment variable in the AWS CodeBuild configuration so it should be changed accordingly.
3. Update the Kubernetes deployment files with the new image tag to apply the latest changes to the EKS cluster. Use the kubectl `kubectl apply -f deployment/` command.
4. Monitor the deployment and application logs in AWS CloudWatch.
