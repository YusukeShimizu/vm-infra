# トラブルシューティング

## SSH接続の問題

### 1. SSH接続できない

**症状**: `ssh dev-vm` コマンドでリモートマシンに接続できない

**確認事項と解決策**:

1. **IPアドレスの確認**
   ```bash
   terraform output dev_vm_public_ip
   ```
   IPアドレスが変わっている場合は、`~/.ssh/config` を更新してください。

2. **ファイアウォールの設定確認**
   - GCPコンソールでVPC ネットワーク > ファイアウォールの設定を確認
   - IPアドレスが変わった場合は、`terraform.tfvars` の `my_ip_cidr` を更新し、`terraform apply` を実行

3. **SSH鍵の確認**
   ```bash
   ls -la ~/.ssh/id_rsa*
   ```
   秘密鍵のパーミッションを修正：
   ```bash
   chmod 600 ~/.ssh/id_rsa
   ```

4. **詳細なSSHデバッグ情報の取得**
   ```bash
   ssh -vvv dev-vm
   ```
   出力されるログを確認して問題を特定します。

5. **VMの状態確認**
   ```bash
   gcloud compute instances describe dev-vm --zone=asia-northeast1-a | grep status
   ```
   VMが停止している場合は起動します：
   ```bash
   gcloud compute instances start dev-vm --zone=asia-northeast1-a
   ```

### 2. VSCodeからSSH接続できない

**症状**: VSCodeからリモートマシンに接続できない

**確認事項と解決策**:

1. **ターミナルからSSH接続ができるか確認**
   ```bash
   ssh dev-vm
   ```

2. **VSCode Remote-SSH拡張機能が最新か確認**
   VSCodeの拡張機能タブで更新されていることを確認。

3. **VSCodeのログを確認**
   1. コマンドパレットを開く（Cmd+Shift+P または Ctrl+Shift+P）
   2. 「Remote-SSH: Show Log」を選択
   3. エラーメッセージを確認

4. **SSH設定ファイルの再作成**
   ```bash
   mkdir -p ~/.ssh
   touch ~/.ssh/config
   
   echo "Host dev-vm
     HostName $(terraform output -raw dev_vm_public_ip)
     User ubuntu
     IdentityFile ~/.ssh/id_rsa
     ServerAliveInterval 60
     ServerAliveCountMax 10" > ~/.ssh/config
   ```

## GCPの認証エラー

### 1. Terraformの認証エラー

**症状**: `terraform init` や `terraform apply` 実行時に認証エラーが発生

**確認事項と解決策**:

1. **GCPサービスアカウントキーの環境変数設定**
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-key-file.json"
   ```

2. **gcloudコマンドでの認証**
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   gcloud auth application-default login
   ```

3. **権限の確認**
   サービスアカウントに必要な権限（Compute管理者など）が付与されているか確認。

### 2. APIエラー

**症状**: APIが有効化されていないというエラーが表示される

**確認事項と解決策**:

1. **APIの有効化状態を確認**
   ```bash
   gcloud services list --available | grep compute
   ```

2. **必要なAPIを有効化**
   ```bash
   gcloud services enable compute.googleapis.com
   gcloud services enable cloudresourcemanager.googleapis.com
   ```

## VM起動の問題

### 1. VMが起動しない

**症状**: VMのステータスが「実行中」にならない

**確認事項と解決策**:

1. **GCPコンソールでのエラー確認**
   Compute Engine > VM インスタンス で詳細を確認

2. **クォータの確認**
   IAM > クォータ で、リソースの上限に達していないか確認

3. **シリアルポートの出力確認**
   ```bash
   gcloud compute instances get-serial-port-output dev-vm --zone=asia-northeast1-a
   ```

4. **VMを再作成**
   ```bash
   terraform taint google_compute_instance.dev_vm
   terraform apply
   ```

## スタートアップスクリプトの問題

### 1. スクリプトが正しく実行されない

**症状**: VMが起動するが、必要なソフトウェアがインストールされていない

**確認事項と解決策**:

1. **スクリプトの実行ログ確認**
   ```bash
   ssh dev-vm
   sudo cat /var/log/syslog | grep startup-script
   ```

2. **スクリプトを手動で実行**
   ```bash
   scp startup-script.sh ubuntu@xxx.xxx.xxx.xxx:~/
   ssh ubuntu@xxx.xxx.xxx.xxx 'chmod +x ~/startup-script.sh && sudo ~/startup-script.sh'
   ```

3. **パーミッションの確認**
   ```bash
   chmod +x startup-script.sh
   ```

## ネットワーク接続の問題

### 1. 外部からVMにアクセスできない

**症状**: SSHでは接続できるが、他のポートにアクセスできない

**確認事項と解決策**:

1. **ファイアウォールルールの確認と追加**
   ```bash
   # 例: 80ポートを開放するルールを追加
   gcloud compute firewall-rules create allow-http \
     --allow tcp:80 \
     --source-ranges=0.0.0.0/0 \
     --target-tags=http-server
   
   # VMにタグを追加
   gcloud compute instances add-tags dev-vm \
     --tags=http-server \
     --zone=asia-northeast1-a
   ```

2. **Terraformファイルに追加する例**
   ```hcl
   resource "google_compute_firewall" "allow_http" {
     name    = "allow-http"
     network = "default"
     allow {
       protocol = "tcp"
       ports    = ["80"]
     }
     source_ranges = ["0.0.0.0/0"]
   }
   ```

## パフォーマンスの問題

### 1. VMのパフォーマンスが低い

**症状**: 開発環境の応答が遅い

**確認事項と解決策**:

1. **リソース使用状況の確認**
   ```bash
   ssh dev-vm 'top -b -n 1'
   ```

2. **マシンタイプのアップグレード**
   `main.tf` を編集してマシンタイプを変更：
   ```hcl
   machine_type = "e2-standard-8"  # より多くのCPUとメモリを持つタイプに変更
   ```
   
3. **ディスクI/Oの改善**
   SSDディスクタイプを指定：
   ```hcl
   boot_disk {
     initialize_params {
       image = "ubuntu-os-cloud/ubuntu-2204-lts"
       size  = 50
       type  = "pd-ssd"  # 標準ディスクからSSDに変更
     }
   }
   ```

4. **リージョンの最適化**
   物理的に近いリージョンを選択して遅延を減らす：
   ```hcl
   region = "asia-northeast1"  # 日本のリージョン
   zone   = "asia-northeast1-a"
   ``` 