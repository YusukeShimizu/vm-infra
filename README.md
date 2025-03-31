# GCE開発環境構築ガイド

このリポジトリは、Google Compute Engine (GCE) 上にSSH接続可能な開発環境を構築し、VSCodeのRemote-SSH機能でリモート開発を行うための実装です。

## 環境仕様

- **マシンタイプ**: e2-standard-4（vCPU 4コア、メモリ16GB）
- **ディスク容量**: 50GB
- **OS**: Ubuntu 22.04 LTS
- **開発ツール**: Git, Docker, GitHub CLI

## 目次

各トピックの詳細なドキュメントは以下のリンクから参照できます：

1. [GCP環境のセットアップ](docs/gcp-setup.md)
2. [SSHキーの設定](docs/ssh-setup.md)
3. [デプロイ手順](docs/deployment.md)
4. [VSCodeからの接続](docs/vscode-connection.md)
5. [Git/GitHubの使用方法](docs/git-github.md)
6. [設定変更方法](docs/configuration.md)
7. [トラブルシューティング](docs/troubleshooting.md)

## クイックスタート

```bash
# 1. リポジトリをクローン
git clone https://github.com/yourusername/gce-dev-environment.git
cd gce-dev-environment

# 2. 環境変数を設定（必要に応じて）
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-key-file.json"

# 3. 設定ファイルの準備
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを編集して必要な値を設定

# 4. Terraformを実行
terraform init
terraform apply

# 5. SSH設定を追加
echo "Host dev-vm
  HostName $(terraform output -raw dev_vm_public_ip)
  User ubuntu
  IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config

# 6. VSCodeでRemote-SSH拡張機能を使用して接続
code .
# その後、左下の緑色のアイコンをクリックして「Remote-SSH: Connect to Host...」から「dev-vm」を選択
```

詳細な手順は各セクションのドキュメントを参照してください。

## 前提条件

- GCPアカウントとプロジェクト
- [Terraform](https://developer.hashicorp.com/terraform/install) がインストールされていること
- [VSCode](https://code.visualstudio.com/download) と [Remote-SSH拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) がインストールされていること
- SSHキーペアが生成されていること
- `curl` コマンドが利用できること

## ライセンス

MIT 