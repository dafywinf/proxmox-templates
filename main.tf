resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = var.template_name
  description = "Template based on: ${var.cloud_image}"
  node_name   = var.proxmox_node
  vm_id       = var.vmid
  tags        = var.tags

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  bios = "ovmf"

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = 2
    numa  = true
    type  = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  machine = "q35"

  disk {
    datastore_id = var.storage
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  efi_disk {
    datastore_id = var.storage
  }


  network_device {
    bridge = "vmbr0"
  }

  # Fails Terraform verification for some reason
  # operating_system {
  #   type = "126"
  # }

  serial_device {
    device = "socket"
  }

  vga {
    type = "serial0"
  }

  agent {
    enabled = true
    trim    = true
    timeout = "2m"
  }

  keyboard_layout = "en-gb"
  template        = true

}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = var.storage
  node_name    = var.proxmox_node
  url          = var.cloud_image
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = var.storage
  node_name    = var.proxmox_node

  source_raw {
    data = <<-EOF
    #cloud-config
    # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/guides/cloud-init

    hostname: ubuntu-noble-host

    autoinstall:
      version: 1

    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(file(var.ssh_proxmox_vm_public_key_path))}
        sudo: ALL=(ALL) NOPASSWD:ALL

    runcmd:
      - apt update
      - apt install -y qemu-guest-agent net-tools
      - timedatectl set-timezone ${var.timezone}
      - systemctl enable ssh
      - echo "Rebooting"
      - reboot
  EOF

    file_name = "user-data-cloud-config.yaml"
  }
}