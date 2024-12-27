# Proxmox VM Template with Terraform

## Requirements

- Proxmox server
- Terraform installed
- Proxmox API credentials

## Notes

Due to defects in the latest version of bpg/proxmox provider, the version is currently fixed:

```bash
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.65.0"
    }
```

https://github.com/bpg/terraform-provider-proxmox/issues/1610

## Pre-Conditions

### Generate SSH Keys (Mac)

Create a file secrets.tfvars in the base directory of this repo:

```bash
#secrets.tfvars content
proxmox_password = "XXXXXXX"
```

### Update Variables

The content of variables.tf will need to be updated

### Generate SSH Keys (Mac)

Create new set of SSH keys if you don't already have a key pair you want to use:

```bash
# Generate a new key pair
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_proxmox_vm

# Ensure the SSH agent is running
eval "$(ssh-agent -s)"

# Add your private key to the agent
ssh-add ~/.ssh/id_ed25519_proxmox_vm
```

---

# Execute Terraform

To deploy the template execute the Terraform

```bash
terraform init
terraform plan
terraform apply -var-file="secrets.tfvars" --auto-approve 
```

---

# Documentation

## Overview

This Terraform configuration defines a Proxmox Virtual Environment (PVE) VM using cloud-init. It ensures a consistent
setup for Ubuntu VMs, with predefined hardware, networking, and initialization settings.

### **Purpose**

- Create a VM from a cloud-init image.
- Automate user provisioning and system configuration via cloud-init.
- Optimise VM resources with proper CPU, memory, and disk configurations.

## Resources

### VM Configuration

**Resource:** `proxmox_virtual_environment_vm`

This resource provisions the virtual machine with the following configurations:

- **Name:** Derived from the `var.template_name`.
- **Description:** Describes the cloud image used (`var.cloud_image`).
- **Node:** Deployed on the specified Proxmox node (`var.proxmox_node`).
- **Startup:** Defines startup order and delay timings.
- **CPU & Memory:**
    - 2 cores (NUMA enabled)
    - Dedicated and floating memory set to 2048MB
- **Disk Configuration:**
    - 20GB disk size
    - Interface: `scsi0`
    - I/O thread enabled
- **Network:** Attached to bridge `vmbr0`.
- **Agent:** QEMU guest agent enabled.
- **Keyboard Layout:** UK (`en-gb`).

### Cloud Image Download

**Resource:** `proxmox_virtual_environment_download_file`

- **Content Type:** ISO
- **Datastore:** `var.storage`
- **Node:** `var.proxmox_node`
- **Source URL:** `var.cloud_image`

This ensures the cloud-init image is downloaded from the specified URL.

### User Data Configuration

**Resource:** `proxmox_virtual_environment_file`

- **Content Type:** Snippet
- **File Name:** `user-data-cloud-config.yaml`
- **Content:** Cloud-init configuration for:
    - Default user setup (`ubuntu`)
    - SSH key provisioning
    - Timezone configuration
    - Enabling SSH service
    - Installing essential packages (`qemu-guest-agent`, `net-tools`)
    - Automatic reboot after initial setup  


