# 設定変更方法

## 1. リソース設定の変更

以下のファイルを編集して設定を変更できます：

### 1.1 `main.tf` - 主要なリソース定義

- マシンタイプの変更
- ディスクサイズの変更
- イメージの変更
- ネットワーク設定の変更

例: マシンタイプを変更する場合
```hcl
resource "google_compute_instance" "dev_vm" {
  name         = "dev-vm"
  machine_type = "e2-standard-8"  # e2-standard-4 から e2-standard-8 に変更
  # ... 他の設定 ...
}
```

例: ディスクサイズを変更する場合
```hcl
boot_disk {
  initialize_params {
    image = "ubuntu-os-cloud/ubuntu-2204-lts"
    size  = 100  # 50GB から 100GB に変更
  }
}
```

### 1.2 `variables.tf` - 変数の定義変更

新しい変数を追加したり、既存の変数の型やデフォルト値を変更できます。

例: リージョンのデフォルト値を変更
```hcl
variable "region" {
  type        = string
  description = "リソースをデプロイするリージョン"
  default     = "us-central1"  # asia-northeast1 から us-central1 に変更
}
```

### 1.3 `terraform.tfvars` - 変数値の変更

変数の具体的な値を変更します。

例:
```hcl
project_id = "new-project-id"  # プロジェクトIDの変更
region     = "europe-west1"     # リージョンの変更
zone       = "europe-west1-b"   # ゾーンの変更
my_ip_cidr = "203.0.113.2/32"   # IPアドレスの変更
```

## 2. 主な変更対象とその場所

| 変更項目          | ファイル         | 変更箇所                                    |
| ----------------- | ---------------- | ------------------------------------------- |
| マシンタイプ      | main.tf          | `machine_type = "e2-standard-4"`            |
| ディスクサイズ    | main.tf          | `size = 50` (boot_disk内)                   |
| OS イメージ       | main.tf          | `image = "ubuntu-os-cloud/ubuntu-2204-lts"` |
| リージョン/ゾーン | terraform.tfvars | `region`, `zone`                            |
| プロジェクトID    | terraform.tfvars | `project_id`                                |
| IP制限            | terraform.tfvars | `my_ip_cidr`                                |

## 3. startup-script.shの更新

VMの初期設定スクリプトを編集して、追加のソフトウェアやツールをインストールできます。

### 3.1 スクリプトの編集

`startup-script.sh`を任意のエディタで編集します：

```bash
vi startup-script.sh
```

### 3.2 変更例

例えば、Node.jsをインストールする場合は以下のようなコードを追加します：

```bash
# Node.jsインストール
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
```

または、Pythonの開発環境を追加する場合：

```bash
# Python開発環境のインストール
apt-get install -y python3-pip python3-venv
pip3 install --upgrade pip
```

## 4. 設定変更の反映方法

設定変更後、以下の手順で変更を反映します：

### 4.1 変更の確認

変更内容をプレビューします：

```bash
terraform plan
```

出力される変更内容を確認し、意図した変更になっているか確認します。

### 4.2 変更の適用

変更内容を適用します：

```bash
terraform apply
```

`yes` と入力して実行を確定します。

### 4.3 特定リソースの再作成

一部の変更はリソースの更新ではなく再作成が必要な場合があります。強制的にリソースを再作成する場合：

```bash
# VMインスタンスを再作成対象としてマーク
terraform taint google_compute_instance.dev_vm

# 変更を適用
terraform apply
```

## 5. 既存VMへの変更反映

### 5.1 startup-scriptの手動反映

スタートアップスクリプトはVM作成時のみ実行されるため、既存VMに手動で反映する必要があります：

```bash
# スクリプトをVMにコピー
scp startup-script.sh ubuntu@xxx.xxx.xxx.xxx:~/

# スクリプトを実行
ssh ubuntu@xxx.xxx.xxx.xxx 'chmod +x ~/startup-script.sh && sudo ~/startup-script.sh'
```

### 5.2 システムの更新

VMに接続し、パッケージを最新の状態に更新：

```bash
ssh dev-vm

# パッケージ更新
sudo apt-get update
sudo apt-get upgrade -y
```

## 6. 設定変更時の注意点

1. **データの永続性**: VMを再作成する変更の場合、VM上のデータは失われます。重要なデータは事前にバックアップを取ってください。

2. **IPアドレスの変更**: VMを再作成すると、IPアドレスが変わる可能性があります。その場合、SSH設定を更新してください。

3. **ダウンタイム**: 一部の変更はリソースの再起動や再作成が必要で、その間サービスが利用できなくなります。

4. **コスト変更**: マシンタイプやディスクサイズを変更すると、課金額も変更されます。GCPの[料金計算ツール](https://cloud.google.com/products/calculator)で事前に確認することをお勧めします。 