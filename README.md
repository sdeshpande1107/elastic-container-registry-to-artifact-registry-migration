# elastic-container-registry-to-artifact-registry-migration
AWS ECR to GCP Artifact Registry Migration Tool

# AWS ECR to GCP Artifact Registry Migration Tool

![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)

A robust Bash script to automate Docker image migration from **Amazon ECR** to **Google Cloud Artifact Registry** while maintaining repository structure and image tags.

## Table of Contents
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Logging](#-logging)
- [Cleanup](#-cleanup)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

## 🚀 Features

- **Complete migration** of all Docker images across registries
- **Automatic discovery** of ECR repositories and their images
- **Detailed logging** for tracking progress and debugging
- **Atomic operations** - continues on failure without losing progress
- **Resource efficient** - cleans up local images after transfer
