# デプロイ手順

## 1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/gce-dev-environment.git
cd gce-dev-environment
```

## 2. Terraform変数の設定

サンプルの変数ファイルをコピーして編集します：

```bash
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars` ファイルを編集し、以下の変数を設定します：

- `project_id`: あなたのGCPプロジェクトID
- `my_ip_cidr`: あなたのグローバルIPアドレス（CIDR形式、例: `203.0.113.1/32`）

グローバルIPアドレスは以下のコマンドで確認できます：

```bash
curl -s https://checkip.amazonaws.com
```

上記で取得したIPアドレスに `/32` を付けて `my_ip_cidr` に設定します。

例：

```hcl
project_id = "my-gcp-project-123456"
my_ip_cidr = "203.0.113.1/32"  # 自分のIPアドレス/32
```

## 3. Terraformの初期化と実行

### 初期化

まず、Terraformを初期化してプロバイダーとモジュールをダウンロードします：

```bash
terraform init
```

### 実行計画の確認

適用前に変更内容を確認します：

```bash
terraform plan
```

出力される内容を確認し、予定通りのリソースが作成されることを確認します。

### 適用

確認後、以下のコマンドでインフラを作成します：

```bash
terraform apply
```

`yes` と入力して実行を確定します。

## 4. デプロイ結果の確認

デプロイが完了すると、VMのパブリックIPアドレスが出力されます：

```
dev_vm_public_ip = "xxx.xxx.xxx.xxx"
```

このIPアドレスをメモしておきます。SSH接続やVSCode接続の設定に使用します。

## 5. VMの状態確認

GCPコンソールから、作成したVMの状態を確認できます：

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. Compute Engine > VM インスタンス を選択
3. `dev-vm` というインスタンスが「実行中」状態になっているか確認

または、gcloudコマンドを使って確認：

```bash
gcloud compute instances describe dev-vm --zone=asia-northeast1-a
```

## 6. リソースの削除

開発環境が不要になった場合は、以下のコマンドでリソースを削除できます：

```bash
terraform destroy
```

`yes` と入力して削除を確定します。これにより、作成したすべてのリソース（VM、ファイアウォールルールなど）が削除され、課金も停止します。

## 7. 部分的な変更の適用

特定のリソースだけを再作成したい場合（例えば、VMのみを再作成）：

```bash
# VMリソースを再作成対象としてマーク
terraform taint google_compute_instance.dev_vm

# 変更を適用
terraform apply
``` 