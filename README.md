# Provision a vSphere virtual machine instance
This Terraform configuration provisions a Linux virtual machine in a vSphere environment.

## Details
By default, this configuration will provision a template image named 'Ubuntu' consisting of 2 CPU / 4 GB RAM / 16 GB storage disk. 

**NOTE** Pretty certain that your template name is not Ubuntu. Using the variables.tf, set it to your template name. Your template sizing may differ. You will need to authenticate to vCenter to be able to perform the installation. Either code your username/password credentials in main (although this is HIGHLY NOT RECOMMENDED) or export the credentials into an environment variable (RECOMMENDED).

### Requirements

Ensure you have a virtual machine network created called "VM Network" or change the vm network to match the virtual machine network
in your vSphere environment.

### Miscellaneous



