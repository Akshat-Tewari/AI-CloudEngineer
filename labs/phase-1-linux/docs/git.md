# Git Workflow Summary: AI-Infra Professional Standards

This document serves as an initial technical reference for git specific workflows.

## 1. Identity & Environment Setup
Before starting any project, ensure your local Git identity is established to properly attribute your professional commit history.

- **Set Identity**:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your-email@example.com"

## 2. Initialize the project root
Starts tracking the project locally. Command has to be run in the project root folder, for tracking empty folders create a .gitkeep file

- **Intialize project root**:
  ```bash
  git init

## 3. Create essential root files
.gitignore: Prevents system junk and secrets from being uploaded
README.md: Primary landing page for project goals and technical tools.

## 4. Connect to GitHub
Create the repository, uncheck the creation of readme and gitignore files. Copy the URL to connect remotely.Standardise the branch from master to main.

- **Connecting to github**:
  ```bash
  git remote add origin <repo-url>
  git branch -M main

## 4. Workflow synchronization
Add: Stage files for commit
Commit: Snapshot / record
Push: Publish the changes to the branch

- **Commands**:
  ```bash
  git add .
  git commit -m "Commit message"
  git push 