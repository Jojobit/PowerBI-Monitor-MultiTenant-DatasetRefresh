# PowerBI-Tenant-Refresh-Monitor

Monitoring Power BI dataset refreshes across multiple workspaces and tenants

## Introduction 📊

Welcome to PowerBI-Tenant-Refresh-Monitor! This PowerShell script automates the monitoring of Power BI dataset refresh statuses across multiple workspaces and tenants. You can leverage this script to keep track of dataset statuses, such as refresh failures and disabled datasets for multiple workspace and multiple tenants. And best part is: you don't need admin rights to do it!

## Features 🔍

- Checks for the presence of required Power BI management modules and installs them if missing.
- Authenticates and connects to the Power BI service for each tenant specified.
- Gathers information about dataset refresh statuses across all workspaces within each tenant.
- Exports CSV reports for dataset refreshes, failures, and disabled statuses.

## Pre-requisites 🛠

- PowerShell. If you need help, check out [New Stars of Data 2023](https://github.com/Jojobit/Speaking/tree/bcfd8393332398d482756ee7cead7f506bb445e9/New%20Stars%20of%20Data%202023)
- Valid credentials (username and password) for each Power BI tenant you wish to monitor and access to workspaces.

## How to Use 🚀

1. Clone this repository to your local machine.
2. Populate the `tenants` folder with text files for each tenant. Each text file should be named after the tenant and contain:
    - Username on the first line
    - Password on the second line
3. Run the script from PowerShell.

## Output Files 🗂

- `refreshes.csv` - A comprehensive list of dataset refresh statuses.
- `failures.csv` - A list of datasets that failed to refresh.
- `disabled.csv` - A list of datasets with disabled refresh statuses.

## Note 📝

- The script retrieves the refresh status of all the datasets in the workspaces that the user credentials have access to, in each tenant
- All data is appended to existing CSV files for historical tracking.

## Let's #BuildSomethingAwesome Together! 🌟

Feel free to contribute, raise issues, or provide feedback. Your participation is highly appreciated!

Happy Monitoring! 😊

