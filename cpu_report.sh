#!/bin/bash

output="vm_max_cpu_monthly_report.csv"
echo "VM Name,Resource Group,Date,Max CPU %" > "$output"

subscription_id=$(az account show --query id -o tsv)

az vm list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv | while read vmname rg; do
  echo "Processing $vmname in $rg..."
  az monitor metrics list \
    --resource "/subscriptions/$subscription_id/resourceGroups/$rg/providers/Microsoft.Compute/virtualMachines/$vmname" \
    --metric "Percentage CPU" \
    --interval P1D \
    --aggregation Maximum \
    --start-time "$(date -u -d '-30 days' +'%Y-%m-%dT00:00:00Z')" \
    --end-time "$(date -u +'%Y-%m-%dT00:00:00Z')" \
    --output json > metric.json

  jq -r --arg vm "$vmname" --arg rg "$rg" '
    .value[0].timeseries[0].data[] |
    select(.maximum != null) |
    [$vm, $rg, .timeStamp[0:10], (.maximum | tostring)] |
    @csv' metric.json >> "$output"
done

echo -e "\n Report ready: $output"
download "$output"
