# AWS Infrastructure Automation with Terraform

## Project Overview
This project demonstrates a professional approach to deploying a web-based portfolio on AWS using Infrastructure as Code (IaC). It's designed to showcase Senior-level infrastructure management skills integrated with modern DevOps practices.

### 🏗 Architecture
- **Compute:** AWS EC2 (Amazon Linux 2) running Apache Web Server.
- **Storage:** AWS S3 for hosting static assets (profile images).
- **Security:** Security Groups for HTTP/SSH access and S3 Bucket Policies for controlled public access.
- **Automation:** Bash scripts via User Data for instant server configuration.

### 🚀 Key Features
- **Dynamic Content:** The website automatically pulls images from a dedicated S3 bucket.
- **Scalability:** Variables-driven configuration for different regions and instance types.
- **Security-First:** Implementation of S3 Public Access Blocks and Bucket Policies.

### 🛠 Tech Stack
- Terraform (IaC)
- AWS (EC2, S3, IAM)
- Bash Scripting
- HTML/CSS

## How to Deploy
1. Clone the repository.
2. Initialize Terraform: `terraform init`.
3. Create your `terraform.tfvars` based on the provided variables.
4. Deploy: `terraform apply`.




📈 Особливості реалізації
Modular Design: Код розділений на логічні блоки, що дозволяє легко додавати нові сервери або сховища.

Security First: Всі секрети та стейти винесені в .gitignore, доступ до веб-ресурсів обмежений необхідними портами.

Automation: Веб-сервер налаштовується автоматично при старті без ручного втручання.