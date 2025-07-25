# Azure VM Max CPU Report Script

This Bash script uses Azure CLI to collect maximum daily CPU usage of all VMs in your Azure subscription over the past 30 days, and saves the data into a CSV file.

## Requirements

- Azure CLI installed and logged in
- `jq` installed (for parsing JSON)

## Usage

Run the script:

```bash
bash cpu_report.sh
