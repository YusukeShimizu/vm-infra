terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPCネットワークの作成
resource "google_compute_network" "vpc_network" {
  name                    = "dev-network"
  auto_create_subnetworks = "true"
}

# ファイアウォールルールの作成
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_cidr]
  target_tags   = ["dev-vm"]
}

# VMインスタンスの作成
resource "google_compute_instance" "dev_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      // 外部IPアドレスを自動的に割り当て
    }
  }

  tags = ["dev-vm"]

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = file("startup-script.sh")
}