# Google Compute Engine開発環境構築設計

## 1. 要件

- GCE上にSSH接続可能な開発環境構築
- VSCode Remote-SSH機能でリモート開発
- セキュリティを考慮し、SSHのみアクセス許可
- Terraformによるインフラのコード化

## 2. 構成

```
[ローカル環境]
VSCode + Remote-SSH拡張機能
       ↓ SSH接続
[GCE VM]
Ubuntu + 開発ツール(Git/Docker/GitHub CLI)
       ↓
[GCP Firewall]
SSH(22)のみ許可
```

## 3. 実装

### 3.1 Terraform設定

```hcl
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [var.my_ip_cidr]
}

resource "google_compute_instance" "dev_vm" {
  name         = "dev-vm"
  machine_type = "e2-medium"
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }
  
  network_interface {
    network = "default"
    access_config {}
  }
  
  metadata_startup_script = file("startup-script.sh")
}
```

### 3.2 スタートアップスクリプト

```bash
#!/bin/bash
apt-get update -y && apt-get upgrade -y
apt-get install -y git curl

# Dockerインストール
apt-get install -y apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce
usermod -aG docker ubuntu

# GitHub CLIインストール
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt-get update -y
apt-get install -y gh
```

## 4. デプロイ手順

1. Terraformファイル準備
2. `terraform init && terraform apply`
3. VMのIPアドレス確認
4. ローカルの~/.ssh/configに設定追加:
   ```
   Host dev-vm
     HostName <VM_IP>
     User ubuntu
     IdentityFile ~/.ssh/id_rsa
   ```
5. VSCodeでRemote-SSH拡張機能から接続

## 5. セキュリティ対策

- ファイアウォールで自分のIPのみSSH許可
- SSHは鍵認証使用
- 不要なポートは開放しない