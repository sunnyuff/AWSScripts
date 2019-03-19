# AWSScripts
Mostly contains automated scripts for DevOps

1. How to automate AWS Security Group - IP Change issues/requests which comes to DevOps.

      Create a new security group only for dev access and attach to the resources needs access -- eg: dev-security-group

      Update the script with new security group ID and AWS region.

      Add a IAM use and attach the supplied policy and update security group mention in policy.

      Ask the developer to configure AWS CLI with the new credentials.

      Please remember the search and update is done on the basis of description field so that field
      in security group should contain the developer name eg "Sunny Home RDP Access", "Sunny Office Mysql Access"
      
      Then the dev has to just run the script and choose the option and update is like match so Sunny Home RDP Access
      just needs Sunny and it will update all mention of that users IP with current user IP.
