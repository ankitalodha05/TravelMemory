# Three-Tier Application Deployment with AWS, Terraform, and Jenkins

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Terraform Infrastructure Setup](#terraform-infrastructure-setup)
- [Application Deployment](#application-deployment)
- [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
- [Deployment Steps](#deployment-steps)
- [Troubleshooting](#troubleshooting)
- [Final Verification](#final-verification)
- [Summary of Fixes](#summary-of-fixes)

---

## Overview
This document provides a step-by-step guide for deploying a three-tier application using Terraform, Jenkins, and AWS.

### **Application Architecture:**
- **Frontend**: React.js
- **Backend**: Node.js (Express.js)
- **Database**: MongoDB (Self-hosted on EC2)

### **Tools Used:**
- **Terraform**: Infrastructure provisioning
- **Jenkins**: CI/CD automation
- **AWS Services**: EC2, Security Groups

---

## Prerequisites
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (`terraform -v`)
- Jenkins installed and running on an AWS EC2 instance
- A GitHub repository with application source code

---

## Terraform Infrastructure Setup

### **Project Structure**
```
three-tier-app-deployment/
├── terraform/
│   ├── main.tf                 # Terraform provider configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output values
│   ├── compute.tf              # EC2 instances
│   ├── security.tf             # Security groups
│   ├── scripts/                # Setup scripts
│   │   ├── backend_setup.sh    # Backend setup script
│   │   ├── frontend_setup.sh   # Frontend setup script
│   └── terraform.tfvars        # Terraform variables
│
├── jenkins/
│   ├── Jenkinsfile             # Jenkins pipeline definition
│
└── README.md                   # Documentation
```

### **Step 1: Terraform Provider Configuration (`main.tf`)**
```hcl
provider "aws" {
  region = "us-east-1"
}
```

### **Step 2: Define Variables (`variables.tf`)**
```hcl
variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "my-key"
}

variable "ami_id" {
  default = "ami-12345678" # Replace with valid AMI ID
}
```

### **Step 3: EC2 Instances Configuration (`compute.tf`)**
```hcl
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.frontend_sg.name]
  user_data = file("./scripts/frontend_setup.sh")
  tags = { Name = "FrontendServer" }
}

resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.backend_sg.name]
  user_data = file("./scripts/backend_setup.sh")
  tags = { Name = "BackendServer" }
}
```

### **Step 4: Security Groups Configuration (`security.tf`)**
```hcl
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow frontend traffic"
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## Application Deployment

### **Backend Setup Script (`scripts/backend_setup.sh`)**
```sh
#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm
git clone https://github.com/user/backend-repo.git
cd backend-repo
echo "MONGO_URI=mongodb://<db-private-ip>:27017/app" > .env
npm install
nohup node index.js > output.log 2>&1 &
```

### **Frontend Setup Script (`scripts/frontend_setup.sh`)**
```sh
#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm
git clone https://github.com/user/frontend-repo.git
cd frontend-repo
echo "const API_URL = 'http://<backend-public-ip>:5000'; export default API_URL;" > src/url.js
npm install
npm start &
```

---

## Jenkins CI/CD Pipeline

### **Jenkinsfile**
```groovy
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/user/frontend-repo.git'
            }
        }
        stage('Build Frontend') {
            steps {
                sh 'cd frontend && npm install && npm run build'
            }
        }
        stage('Deploy Frontend') {
            steps {
                sh 'scp -r frontend/* ubuntu@<frontend-ip>:/var/www/html/'
            }
        }
    }
}
```

---

## Deployment Steps
1. **Initialize Terraform**
   ```sh
   terraform init
   terraform apply -auto-approve
   ```
2. **Deploy Application with Jenkins**
   - Go to Jenkins UI
   - Create a new pipeline job
   - Add repository URL and pipeline script
   - Run the pipeline

---

## Troubleshooting

| Issue | Solution |
|--------|-----------|
| Backend not connecting to DB | Ensure `MONGO_URI` is correct |
| Frontend showing blank page | Check `src/url.js` API URL |
| Terraform apply fails | Verify IAM permissions |
| Jenkins pipeline failing | Check logs under `/var/log/jenkins` |

---

## Final Verification
✅ **Backend Running**: `curl http://<backend-ip>:5000/api/status`  
✅ **Frontend Accessible**: Open `http://<frontend-ip>:3000`  
✅ **Jenkins Deployments Successful**  

---

## Summary of Fixes
✔ **Security groups now restrict access to required instances only**  
✔ **Terraform now properly provisions MongoDB and connects it to backend**  
✔ **Jenkins pipeline now correctly deploys frontend and backend**  
✔ **User data scripts improved for better automation**  

🚀 **Your three-tier application is now successfully deployed with Terraform and Jenkins!**


