# Terraform Project: Cloud Monitoring Stack on AWS (EC2 + Grafana + Prometheus)

## Description
Automated deployment of a complete monitoring stack using Terraform, integrating Grafana (running on EC2) with Prometheus and AWS CloudWatch to visualize metrics across infrastructure resources.

---

## Key Highlights

### Infrastructure Automation
- Provisioned an EC2 instance via Terraform to host Grafana and Prometheus.
- Used **user data** scripts for automated installation and configuration at launch.

### Networking
- Created a **custom VPC**, public subnet, and Internet Gateway.
- Configured **Security Groups** with strict inbound rules to allow Grafana dashboard access and secure Prometheus scraping.

### Monitoring Integration
- Configured **Prometheus node exporters** on EC2 to collect CPU, memory, disk, and network metrics.
- Integrated **AWS CloudWatch metrics** into Grafana for unified visibility across infrastructure.

### Automation & Modularity
- Used **Terraform modules** for compute, networking, and security to simplify management and reusability.
- Stored **Terraform remote state** in S3 with DynamoDB for state locking and collaboration.

### Alerting Setup
- Configured **Grafana alert rules** and **SNS notifications** for critical thresholds (e.g., high CPU usage, instance downtime).
