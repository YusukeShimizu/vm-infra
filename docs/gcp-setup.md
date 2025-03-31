# GCP環境のセットアップ

## 1. GCPプロジェクトの作成

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセスしてログイン
2. 画面上部の「プロジェクト選択」をクリック
3. 「新しいプロジェクト」をクリック
4. プロジェクト名を入力して「作成」をクリック
5. 作成したプロジェクトを選択

## 2. 必要なAPIの有効化

以下のAPIを有効にする必要があります：

1. Compute Engine API
2. Cloud Resource Manager API

有効化する手順：

1. [APIライブラリ](https://console.cloud.google.com/apis/library) に移動
2. 「Compute Engine API」を検索し、選択して「有効にする」をクリック
3. 同様に「Cloud Resource Manager API」も有効化

## 3. サービスアカウントと認証の設定

### 3.1 サービスアカウントの作成

1. [IAMとサービスアカウント](https://console.cloud.google.com/iam-admin/serviceaccounts) に移動
2. 「サービスアカウントを作成」をクリック
3. サービスアカウント名を入力（例: `terraform-account`）
4. 「作成と続行」をクリック
5. ロールとして「Compute管理者」と「Service Account User」を選択
6. 「完了」をクリック

### 3.2 サービスアカウントキーの作成

1. 作成したサービスアカウントの行の右端にある「アクション」（三点リーダー）をクリック
2. 「鍵を管理」をクリック
3. 「鍵を追加」→「新しい鍵を作成」→「JSON」→「作成」
4. JSONキーファイルがダウンロードされます
5. このファイルを安全な場所に保存し、環境変数に設定するか、Terraformの設定ファイルから参照します

### 3.3 認証の設定

**方法1: 環境変数を使用する場合**

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-key-file.json"
```

**方法2: gcloudコマンドを使用する場合**

```bash
# gcloudのインストール（未インストールの場合）
# macOSの場合
brew install --cask google-cloud-sdk

# 認証設定
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
gcloud auth application-default login
```

## 4. ファイアウォール設定の確認

デフォルトのVPCネットワークでは、SSHポート（22）が開放されていますが、セキュリティのために自分のIPからのアクセスのみに制限することを推奨します。これはTerraformコードで自動的に行われます。

## 5. GCPリソース管理

### 5.1 コンソールからの確認

[GCPコンソール](https://console.cloud.google.com/)から、以下の場所で作成したリソースを確認できます：

- Compute Engine > VM インスタンス
- VPC ネットワーク > ファイアウォール ルール

### 5.2 コストの監視

予期しない請求を避けるために、[請求ページ](https://console.cloud.google.com/billing)で予算とアラートを設定することをお勧めします：

1. 請求 > 予算とアラート
2. 「予算を作成」をクリック
3. プロジェクトとサービスを選択
4. 予算額とアラートのしきい値を設定

### 5.3 インスタンスの停止/起動

使用しない時間帯はインスタンスを停止することでコストを節約できます：

**コンソールから：**
1. Compute Engine > VM インスタンス
2. インスタンスの横にあるチェックボックスを選択
3. 「停止」または「開始」ボタンをクリック

**gcloudコマンドで：**
```bash
# 停止
gcloud compute instances stop dev-vm --zone=asia-northeast1-a

# 起動
gcloud compute instances start dev-vm --zone=asia-northeast1-a
``` 