# cloudDevopsPro3
# Coworking Space Microservice
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
sh run_sql.sh
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

## Further Release process
1. Commit your code changes to the GitHub repository.
2. Automatically trigger the AWS CodeBuild pipeline on GitHub `push` action to build and push a new Docker image to AWS ECR. Image is built and pushed with an `$CODEBUILD_BUILD_NUMBER` defined as an environment variable in the AWS CodeBuild configuration so it should be changed accordingly.
3. Update the Kubernetes deployment files with the new image tag to apply the latest changes to the EKS cluster. Use the kubectl `kubectl apply -f deployment/` command.
4. Monitor the deployment and application logs in AWS CloudWatch.
