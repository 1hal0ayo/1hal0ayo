#!/bin/bash

# Create main project directories
mkdir -p MyWebShop/{frontend,backend,database,scripts,ai,docs,docker}

# Frontend directories
mkdir -p MyWebShop/frontend/{css,js,images}

# Backend directories
mkdir -p MyWebShop/backend/{routes,models,controllers}

# Database directory
touch MyWebShop/database/shop_schema.sql

# AI Image Prediction directory
mkdir -p MyWebShop/ai/{models,data}

# Docker Setup
mkdir -p MyWebShop/docker/{nginx,postgres}

# Create a basic README file
cat <<EOL > MyWebShop/README.md
# My Web Shop Project

## Overview
This project is a full-stack web application that uses encryption, AI image prediction, and SQL database integration, all wrapped in Docker containers.

### Project Structure
- **frontend**: Contains HTML, CSS, and JS files
- **backend**: Node.js/Express application
- **database**: PostgreSQL database schema
- **ai**: AI image prediction model and training data
- **docker**: Docker configuration files

EOL

echo "File structure created successfully."
