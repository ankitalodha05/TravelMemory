
# Three-Tier Application Deployment

## Table of Contents
- [Introduction](#introduction)
- [Infrastructure Setup Using Terraform](#infrastructure-setup-using-terraform)
- [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
- [Application Deployment](#application-deployment)
- [Troubleshooting](#troubleshooting)
- [Validation](#validation)
- [Final Verification](#final-verification)

## Introduction
This document outlines the steps for deploying a three-tier application using Terraform, Jenkins, and AWS. The application consists of:

- **Frontend**: React.js
- **Backend**: Node.js (Express)
- **Database**: MongoDB (MongoDB Atlas)

## Infrastructure Setup Using Terraform

Terraform is used to provision AWS infrastructure, including EC2 instances for frontend, backend, and MongoDB.

### Terraform Configuration Files
#### **`main.tf`**
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  key_name      = "my-key"
  security_groups = [aws_security_group.frontend_sg.name]

  user_data = file("./scripts/frontend_setup.sh")

  tags = {
    Name = "FrontendServer"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  key_name      = "my-key"
  security_groups = [aws_security_group.backend_sg.name]

  user_data = file("./scripts/backend_setup.sh")

  tags = {
    Name = "BackendServer"
  }
}
```

#### **`security.tf`**
```hcl
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow inbound traffic on port 3000"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow inbound traffic on port 5000"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
![image](https://github.com/user-attachments/assets/5d867d59-f087-4f02-86dd-169d0b9a8b43)

![image](https://github.com/user-attachments/assets/e98b3035-3d69-466e-a410-c30e973f71af)

## Jenkins CI/CD Pipeline

Jenkins is used to automate the deployment process.

### **Jenkinsfile**
```groovy
pipeline {
    agent any
    
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/UnpredictablePrashant/TravelMemory.git'
            }
        }
        
        stage('Build Frontend') {
            steps {
                sh 'cd frontend && npm install && npm run build'
            }
        }
        
        stage('Build Backend') {
            steps {
                sh 'cd backend && npm install'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'cd backend && pm2 start index.js'
            }
        }
    }
}
```

## Application Deployment

### 1️⃣ **Clone Repository**
```sh
git clone https://github.com/UnpredictablePrashant/TravelMemory.git
cd TravelMemory
```

### 2️⃣ **Set Up Backend**
```sh
cd backend
nano .env
```
Add the following variables:
```sh
MONGO_URI=mongodb+srv://vika2k:Alfacbe121981@cluster0.ra3ai.mongodb.net/
PORT=5000
```
Start the server:
```sh
npm install
node index.js
```

### 3️⃣ **Set Up Frontend**
```sh
cd ../frontend
nano src/url.js
```
Update with:
```js
const API_URL = 'http://<backend-public-ip>:5000';
export default API_URL;
```
Install dependencies and start:
```sh
npm install
npm start
```
![image](https://github.com/user-attachments/assets/ff63282d-c310-40a8-a3f4-f64bfc4c1e23)
![image](https://github.com/user-attachments/assets/fc646ce4-53d7-4e07-9f6b-9d21c3210c5b)

![image](https://github.com/user-attachments/assets/29e0837b-420d-4843-9eae-317cf267369b)

![image](https://github.com/user-attachments/assets/f1dfc677-fad3-4e81-a81d-40e8a45c806e)
![image](https://github.com/user-attachments/assets/de5c33e6-0256-42a9-b519-d9b62b46d965)

## Troubleshooting

### 1️⃣ **`Cannot GET /api/some-endpoint`**
Ensure backend routes are correctly defined in `index.js`:
```js
app.get("/api/some-endpoint", (req, res) => {
    res.json({ message: "API working!" });
});
```

### 2️⃣ **Frontend Cannot Connect to Backend**
Ensure `src/url.js` has the correct backend IP.

### 3️⃣ **Permission Issues**
Use `sudo` when required, or fix permissions:
```sh
sudo chown -R ubuntu:ubuntu ~/TravelMemory
```

### 4️⃣ **Ports Not Open**
Ensure security groups allow traffic on ports **3000** and **5000**.

## Validation
1. **Backend**: `curl http://<backend-ip>:5000/api/some-endpoint`
2. **Frontend**: Open `http://<frontend-ip>:3000` in a browser.

## Final Verification
✅ **Backend Running**: Confirm MongoDB connection & API responses.
✅ **Frontend Running**: UI loads successfully and connects to the backend.
✅ **Jenkins Deployments**: Pipeline successfully runs and updates the application.

---
🚀 **Project Successfully Deployed!**
