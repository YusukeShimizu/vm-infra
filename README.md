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

## 環境変数の設定

1. 環境変数テンプレートのコピー
```bash
cp .env.example .env
```

2. `.env`ファイルを編集し、以下の情報を設定：
   - GCPプロジェクトID
   - リージョンとゾーン
   - インスタンス名とマシンタイプ
   - あなたのIPアドレス（CIDR形式）
   - サービスアカウントキーのパス
   - SSH設定
   - GitHub設定

3. Terraform変数の設定
```bash
cp terraform.tfvars.example terraform.tfvars
```

4. `terraform.tfvars`を編集し、必要な値を設定

## クイックスタート

```bash
# 1. リポジトリをクローン
git clone https://github.com/yourusername/gce-dev-environment.git
cd gce-dev-environment

# 2. 環境変数の設定
cp .env.example .env
# .envを編集して必要な値を設定

# 3. Terraform変数の設定
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを編集して必要な値を設定

# 4. Terraformを実行
terraform init
terraform apply

# 5. VSCodeでRemote-SSH拡張機能を使用して接続
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

## セキュリティに関する注意事項

- サービスアカウントキーやSSH秘密鍵などの機密情報は、リポジトリにコミットしないでください
- 環境変数やシークレット情報は、`.env`ファイルや`terraform.tfvars`で管理し、これらは`.gitignore`に含まれています
- 本番環境の認証情報は、適切なシークレット管理サービスを使用してください
- IPアドレスなどの環境固有の設定値は、`.env`ファイルで管理し、リポジトリにはコミットしないでください

## ライセンス

MIT 