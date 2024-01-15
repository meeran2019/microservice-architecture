Designing and Implementing a Resilient and Scalable Platform for Microservice Architecture

1. Infrastructure Platform Selection:
Compare to Onprem which require investment in hardware and lack of ability to scale easily.
Cloud service AWS offer greater flexibility and wide range of managed services. It offers auto-scaling features that allow to automatically adjust the resources based on demand.

2. Orchestration Technology Selection:
Kubernetes provides container orchestration, automatic scaling, and self-healing capabilities. Managed kubernetes like AWS EKS reduces the complexity to manage control plane components and scale easily with changing load.

3. Infrastructure Automation:
Infrastructure as code (IaC) tool helps to define infrastructure components, networking, and security in code which enables versioning, reproducibility, and easy modifications. Terraform is vendor neutral and support multiple providers.

4. Microservice Deployment Strategy:
Kubernetes which support recreate (have downtime) and rollingupdate deployment strategy. 

5. Infrastructure Testing:
Implement automated testing for infrastructure using tools like Terratest or Packer. Include unit tests, integration tests, and end-to-end tests for validating the infrastructure setup and deployment processes. Test the scalability of the infrastructure under varying loads.

6. Configuration Management:
Utilize tools like Helm for managing Kubernetes applications and configuration. Store configuration values in Kubernetes ConfigMaps and Secrets. Ensure that the configuration is version-controlled along with the application code.

7. Monitoring Approach:
Implement observability using tools like Prometheus for metrics, Grafana for visualization, and ELK stack (Elasticsearch, Logstash, Kibana) for log management. Set up alerts based on key performance indicators and use Kubernetes probes for application health checks.

