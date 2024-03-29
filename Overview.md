# Designing and Implementing a Resilient and Scalable Platform for Microservice Architecture

## Solution Overview:

It is 3 tier architecture which consists of front end, back end and database layer.

#### 1. Infrastructure Platform Selection:
Compare to Onprem which require investment in hardware and lack of ability to scale easily.
Cloud service AWS offer greater flexibility and wide range of managed services. It offers auto-scaling features that allow to automatically adjust the resources based on demand.

#### 2. Orchestration Technology Selection:
Kubernetes provides container orchestration, automatic scaling, and self-healing capabilities. Managed kubernetes like AWS EKS reduces the complexity to manage control plane components and scale easily with changing load.

#### 3. Infrastructure Automation:
Infrastructure as code (IaC) tool helps to define infrastructure components, networking, and security in code which enables versioning, reproducibility, and easy modifications. Terraform is vendor neutral and support multiple providers.

#### 4. Microservice Deployment Strategy:
Kubernetes by default which support recreate and rollingupdate deployment strategy. Using ArgoCD Rollout feature which supports Blue green and Canary deployment.

#### 5. Infrastructure Testing:
TFSec is a static analysis tool used to scan terraform code to identify and highlight gaps from security aspect from an infrastructure.

#### 6. Configuration Management:
Kubernetes ConfigMaps and secrets which helps to store configuration and secret values.

#### 7. Monitoring Approach:
New Relic is observability platform that provides solutions for Application Performance Monitoring, Infrastructure Monitoring and Log management. 
New Relic Logs which send logs from EKS Cluster to New relic for centralized log managesment.
Alert policies in New Relic used to notify any issues or anamolies in EKS environment.

## Tools and Technologies Used:

- **Infrastructure:** AWS Cloud, VPC, EKS, Cloudwatch, RDS Aurora, EC2, ELB  
- **Source Code Management:** Git, GitHub  
- **Infrastructure as Code:** Terraform, TFSec  
- **Operating System:** Linux  
- **Containarization:** Docker  
- **Container Orchestration:** EKS  
- **Package Manager:** Helm  
- **Continuos Integration:** Jenkins    
- **Continuos Delivery:** ArgoCD  
- **Logging and Monitoring:** Cloud Watch, New Relic  
- **Programming Language and YAML files:** Javascript, Java, Manifest file, Jenkinsfile, Dockerfile.

## CI CD Proccess:

Continuos Integration process is managed by using Jenkins Pipeline to build, test, generate artifact, generate docker image, push to ECR and update manifest.

- Install Jenkins in EC2 with master and slave architecture.
- Use multiple slave nodes to select agent with the help of labels.
- Jenkins pipeline support declarative and scripted pipeline.
- Create the shared library for the java and nodejs application.
- Shared library will call dynamically from Jenkinsfile.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/jenkins

![Alt text](<CI CD Flow_v2.png >)

**For Java applications:**  
- When developer push the code to Github, with the help of webhook, it will trigger the jenkins pipeline. From github, source code is downloaded which includes Jenkinsfile, pom.xml and Dockerfile.
- pom.xml which defines the dependencies, plugins and build settings for sonarqube, jfrog. 'mvn clean install' will validate, compile, test and deploy into local m2 repository.
- Sonarqube stage which is used to check the code quality to adherence to coding standard and waitforqualitygate report. 
- Checkmarx stage used to check vulnarabilities to analyze common issues like SQL Injection, Cross site scripting and other vulnarabilities.
- Once artifact jar and configuration files are generated, 'mvn clean deploy' will deploy into artifacts.
- Dockerfile which contains instruction to generate the image. For ECR, use the AWS user and 'aws ecr get-login-password' to create the docker login. 'docker push' to push the imageinto ECR.
- Update the latest image version in helm values.yaml file to reflect the latest image.
- ArgoCD which is running in cluster will trigger the deployment.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/spring-boot-backend-code which contains the Dockerfile and Jenkinsfile.

**For nodejs application:**
- When developer push the code to Github, with the help of webhook, it will trigger the jenkins pipeline. From github, source code is downloaded which includes Jenkinsfile and Dockerfile.
- 'npm run lint' and 'npm run build' are used to generate the artifacts.
- Sonarqube stage which is used to check the code quality to adherence to coding standard and waitforqualitygate report. 
- Checkmarx stage used to check vulnarabilities to analyze common issues like SQL Injection, Cross site scripting and other vulnarabilities.
- Once artifacts are generated, push the artifacts in to Jfrog with API call.
- Dockerfile which contains instruction to generate the image. For ECR, use the AWS user and 'aws ecr get-login-password' to create the docker login. 'docker push' to push the imageinto ECR.
- Update the latest image version in helm values.yaml file to reflect the latest image.
- ArgoCD which is running in cluster will trigger the deployment.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/react-frontend-code which contains the Dockerfile and Jenkinsfile.

## Architecture Overview:

Below architecture diagram gives the high level overview of the process and tools involved. 

- AWS infrastructure including EKS and other services are created by using Terraform and scanned by TFSec for security check. 
- ArgoCD is pull and gitops based CD tool used for deployment whenever changes in source repo which support kubernetes manifest, Helm template and Kustomize.
- For monitoring, New Relic gives the  dashboard and support both onprem and cloud.
- Kubernetes resource objects like deployment, service are created and templatized using HELM.
- For front end and backend application, deployed using deployment and exposed through service
- Services are exposed through ingress and access by end customer.
- For database, AWS Aurora provides 3 time faster than postgresql.

![Alt text](EKS.png)

### Elastic Kubernets Service(EKS):

Amazon Elastic Kubernetes Service (EKS) is AWS managed service that scales, manages and deploy containerized applications. It runs across AZ for high availability. It consists of a control plane and data plane components (worker nodes). It comes with add on like VPC CNI, EBS, EFS, Core DNS for integration with other services.  

- Kubernetes cluster and worker nodes are provisioned using terraform.
- CLI 'kubectl' is installed on the EC2 to interact with cluster and update the kube config by using 'aws eks update-kubeconfig --region us-east-1 --name eks-cluster' 
- Security group is used to allow only inbound traffic for worker nodes.
- Kubernetes resources are templatized and managed by using Helm.
- Create the kubernetes resources like deployment, service, ingress etc to deploy the application.
- For database credentials, secret manager is used to get the credentials.
- Horizontal Pod Autoscaler (HPA) resource is used to increase or decrease the replica based on the load.
- Give the pod level permission to access the AWS resources.
- Ingress resource is used to route the traffic based on the host and path.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/helm

### Terraform and TFSec:
Terraform is vendor neutral and support multiple providers. It consists of open source, enterprise and cloud based. For cloud based, no need of manage state file and handled by cloud itself. For other, require to integrate with S3 and DynamoDB to maintain state file locking. For cloud, secrets can be passed as sensitive variable. For other, need to integrate with Vault or other secret solutions.  

- TFSec is security scanning on code and gives recommendation on any open port used or unencryped etc.
- Utilize the bootstrap to install the required software once EC2 is created.
- Create the modules for each resources and use that common module to create infra resources.
- Utilize workspace to maintain the different variables depends upon the environment.
- In EC2, install the terraform through userdata or use the terraform cloud.
- From CLI or through Jenkins, run the command "terraform init/validate/plan/apply" to create the infrastructure.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/terraform

### ArgoCD:
Argo CD is declarative, GitOps continuos delivery tool for kubernetes. It pull the code directly from Git source and deploy it directly into kubernetes. It support CLI, UI and YAM file.  
- Install the argocd using userdata.
- It consists of source where the kubernetes manifest or helm template contains and destination where the kubernetes cluster to deploy.
- It support autoprune and self heal to sych with repo and auto update the resource if manually updated.
- Whenever helm repo is updated, based on reconcillation_timout, it detect the changes and do the deployment.
- ArgoCD Rollout is CRD which support blue green and canary deployments.
- For code snippet, refer the https://github.com/meeran2019/microservice-architecture/tree/develop/argo-cd

### AWS Cloud:
It consists of different services from VPC, Region, Availability zone, Public subnet, Private subnet, ELB, Route53, Secret manager, Aurora database, IAM. 

- Amazon Aurora is fully managed database engine compatible with PostgreSQL and gives 3x performance compare to normal postgresql. It support multi AZ for high availability and data encryption at rest and intransit. 
- Secret manager is used to store database credentials and to access from POD.
- Route 53 is DNS service which helps to map custom domain name with ELB URL.
- ELB is created as part of ingress controller. From Ingress resource, route traffic to backend resource.
- For EKS, number of nodes can be adjusted based on autoscaling group.
- Multi AZ helps to achieve high availability.
- EC2 is created which contains necessary software agent like Kubectl, Helm, New Relic, ArgoCD and Jenkins.
- For security, NACL and Security group allows only from specific IPs and security groups.

### New Relic:
It support both onprem and multi cloud and to use as centralized logging and monitoring solution.

- New relic account to be opened.
- New relic agent to install in kubernetes.
- It get authenticated by cient id and secret.
- It takes few minutes to reflect logs in new relic dashboard.
- For code snippet, refer https://github.com/meeran2019/microservice-architecture/blob/develop/terraform/bootstrap.tpl