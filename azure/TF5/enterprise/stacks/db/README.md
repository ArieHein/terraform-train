# Stack db01

## Purpose

This stack will create an Azure SQL Server service and one SQL Server Database service.

## Input Variables

SQL Server Name
SQL Server Version
SQL Server Database Name
SQL Server Database TIER
SQL Server Database SIZE

## Process

Based on Input variables, an Azure SQL Server instance will be created
Based on Input variables, an Azure SQL Database instance will be created on the Azure SQL Server.
The sa user and password will be created internally and stored as secrets in a Keyvault.
The service principle name will have access to the Secrets with a predefined access policy.
Custom access policy can be added for other objects.
Access to the Keyvault is limited.
Use Pipelines for activity on the database that requires sa permissions using a share variable group connected to the keyvault.

## Output Variables
