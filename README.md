### ✅ Final `README.md` for Your Project

# 🚀 Static Website Deployment using AWS CodePipeline & CodeDeploy

This project demonstrates a complete **CI/CD pipeline** setup to automatically deploy a static website (HTML + CSS + GIFs) on an **Amazon EC2 instance** using **AWS CodePipeline**, **CodeDeploy**, and **CodeBuild**.

---

## 📁 Project Structure

```
.
├── index.html
├── style.css
├── buildspec.yml
├── appspec.yml
└── scripts
    ├── install_nginx.sh
    └── start_nginx.sh
```

---

## 🛠️ Tech Stack

- **Frontend**: HTML, CSS (with cool GIFs 🎉)
- **Version Control**: Git + GitHub
- **Deployment Services**:
  - AWS CodePipeline (CI/CD)
  - AWS CodeBuild (build & copy files)
  - AWS CodeDeploy (to EC2)
  - Amazon EC2 (Web server)
  - NGINX (Web server)

---

## 📦 AWS Services Used

| Service        | Purpose                                |
|----------------|----------------------------------------|
| **EC2**        | Hosts the deployed static site         |
| **CodePipeline** | Automates the CI/CD process          |
| **CodeDeploy** | Deploys files from S3 to EC2           |
| **CodeBuild**  | Copies & prepares files for deployment |
| **S3**         | Stores built artifacts                 |
| **IAM**        | Manages permissions for services       |

---

## 🚧 CI/CD Flow

1. **Code pushed to GitHub**
2. **CodePipeline** triggers automatically
3. **CodeBuild** copies required files and uploads them to S3
4. **CodeDeploy** takes those artifacts and:
    - Installs NGINX (if not present)
    - Copies files to `/usr/share/nginx/html/`
    - Starts NGINX
5. **Website goes live on EC2 public IP**

---

## ⚙️ Setup & Configuration

### 1. GitHub Repo
Make sure your repo contains:
- `index.html`, `style.css`
- `scripts/install_nginx.sh`, `scripts/start_nginx.sh`
- `appspec.yml`
- `buildspec.yml`

### 2. EC2 Setup
- Launch a Linux EC2 instance (Amazon Linux 2 preferred)
- Open ports **80 (HTTP)** and **22 (SSH)** in the Security Group
- Install **CodeDeploy agent** using the below script:

```bash
#!/bin/bash
sudo yum update -y
sudo yum install ruby wget -y
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent
```

### 3. IAM Role
Create:
- **EC2 Role** with `AmazonEC2RoleforAWSCodeDeploy`
- **CodePipeline Role** with required permissions (S3, CodeBuild, CodeDeploy)

### 4. buildspec.yml (for CodeBuild)

```yaml
version: 0.2

phases:
  install:
    commands:
      - echo Installing NGINX
      - sudo yum update -y
      - sudo yum install nginx -y
  build:
    commands:
      - echo Copying HTML and CSS files
      - cp index.html style.css $CODEBUILD_SRC_DIR
artifacts:
  files:
    - index.html
    - style.css
    - appspec.yml
    - scripts/*
```

### 5. appspec.yml (for CodeDeploy)

```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /usr/share/nginx/html

hooks:
  BeforeInstall:
    - location: scripts/install_nginx.sh
      timeout: 60
      runas: root

  AfterInstall:
    - location: scripts/start_nginx.sh
      timeout: 30
      runas: root
```

### 6. Scripts

#### install_nginx.sh

```bash
#!/bin/bash
echo "Updating Server"
sudo yum update -y
echo "Installing NGINX"
sudo yum install nginx -y
echo "NGINX installation complete"
```

#### start_nginx.sh

```bash
#!/bin/bash
echo "Starting NGINX"
sudo systemctl start nginx
sudo systemctl enable nginx
echo "NGINX is now active"
```

---

## 🐞 Common Errors & Fixes

| Error | Solution |
|------|----------|
| `ScriptMissing: Script does not exist at specified location` | Ensure correct script paths in `appspec.yml` and all files are committed and pushed to GitHub |
| `Unit nginx.service could not be found` | NGINX wasn’t installed, fixed by adding `sudo yum install nginx -y` in `install_nginx.sh` |
| `chmod: cannot access scripts/...` | Happens when trying to access scripts before deployment – access them only **after deployment inside the EC2 deployment-archive** |
| `CRLF vs LF warnings` | Ignored or fixed using `core.autocrlf` Git config |
| `fatal: The current branch has no upstream branch` | Fixed using `git push --set-upstream origin <branch-name>` |

---

## 📸 Screenshots (Optional)

> Include in your LinkedIn post:
- ✅ NGINX `active (running)` terminal status
- 🌐 Website live on EC2 IP
- ✅ CodePipeline with all stages green
- ✅ CodeDeploy deployment lifecycle

---

## 🌟 Author

**Zaheer Mulani**  
> B.Tech IT | MERN Stack + DevOps 
> Working on end-to-end deployment skills 🚀

---

Feel free to ⭐ the repo if you found it helpful!
