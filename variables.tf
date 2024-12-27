variable "vmid" {
  description = "The VM ID for the Proxmox instance"
  default     = 9999
}


variable "cloud_image" {
  description = "Cloud Image Download Releases Path"
  default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
}

variable "template_name" {
  description = "The name for the newly created template"
  default     = "ubuntu-24-04-noble-numbat-template"
}

variable "proxmox_username" {
  description = "Proxmox Username"
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox Password"
  sensitive   = true
}

variable "proxmox_ssh_username" {
  description = "Proxmox SSH Username - used local private key"
  default     = "root"
}


variable "proxmox_endpoint" {
  description = "Proxmox API URL"
  default     = "https://proxmox.local:8006/"
}

variable "proxmox_node" {
  description = "Proxmox node to deploy the VM"
  default     = "proxmox"
}

variable "ssh_proxmox_vm_public_key_path" {
  description = "Path to the SSH public key deployed to VMs"
  default     = "~/.ssh/id_ed25519_proxmox_vm.pub"
}

variable "storage" {
  description = "Storage location for the VM disks"
  default     = "local-ssd"
}

variable "user" {
  description = "Default Cloud-Init username"
  default     = "ubuntu"
}

variable "timezone" {
  description = "Timezone to set on the VM template"
  default     = "Europe/London"
}

variable "snippets" {
  description = "Path to store Cloud-Init snippets"
  default     = "/mnt/ssd/snippets"
}

variable "tags" {
  description = "The tags to associate with the template"
  default = ["cloudinit", "ubuntu-template", "noble-numbat", "terraform-generated"]
}