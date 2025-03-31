# SSHキーの設定

## SSHキーペアの生成（未作成の場合）

ローカルマシンで以下のコマンドを実行してSSHキーペアを生成します：

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

処理中にパスフレーズの入力を求められますが、空のままEnterを押すこともできます（セキュリティ向上のためパスフレーズ設定を推奨）。

## 既存のSSHキーの確認

以下のコマンドで既存のSSHキーを確認できます：

```bash
ls -la ~/.ssh
```

通常、`id_rsa`（秘密鍵）と`id_rsa.pub`（公開鍵）が存在するはずです。

## SSHキーの権限設定

SSHキーが正しく機能するためには、適切な権限設定が必要です：

```bash
# 秘密鍵は所有者のみ読み書き可能に設定
chmod 600 ~/.ssh/id_rsa

# 公開鍵は読み取り可能に設定
chmod 644 ~/.ssh/id_rsa.pub

# .sshディレクトリ全体のパーミッション設定
chmod 700 ~/.ssh
```

## SSHキーをGCPに登録する方法

### Terraformでの自動設定

`main.tf`の`google_compute_instance`リソースに以下のようにメタデータとして追加します：

```hcl
metadata = {
  ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}
```

このコードは現在の`main.tf`に既に含まれているため、特に変更は必要ありません。

### 手動での設定

GCPコンソールから手動で登録することもできます：

1. GCPコンソールへログイン
2. Compute Engine > メタデータ > SSHキー タブを選択
3. 「追加」ボタンをクリック
4. `~/.ssh/id_rsa.pub`の内容をコピーして貼り付け
5. 「保存」をクリック

## VSCodeでのSSH設定

### SSH設定ファイルの編集

ローカルマシンの `~/.ssh/config` ファイルを編集します：

```bash
vi ~/.ssh/config
```

以下の内容を追加します：

```
Host dev-vm
  HostName xxx.xxx.xxx.xxx  # TerraformのapplyコマンドでアウトプットされたIPアドレス
  User ubuntu
  IdentityFile ~/.ssh/id_rsa  # あなたのSSH秘密鍵のパス
  ServerAliveInterval 60
  ServerAliveCountMax 10
```

`ServerAliveInterval`と`ServerAliveCountMax`はネットワーク接続が切断されるのを防ぐオプションです。

## SSH接続のテスト

設定が正しいか確認するために、コマンドラインからSSH接続をテストします：

```bash
ssh dev-vm
```

接続に成功すると、VMのコマンドラインにアクセスできます。

## SSH接続のトラブルシューティング

接続に問題がある場合は、以下を確認してください：

1. IPアドレスが正しいか確認
```bash
terraform output dev_vm_public_ip
```

2. より詳細な情報を得るためにデバッグモードでSSH接続
```bash
ssh -v dev-vm
```

3. SSH鍵のパーミッションを確認
```bash
ls -la ~/.ssh/id_rsa*
```

4. ファイアウォールルールが正しく設定されているか確認
```bash
gcloud compute firewall-rules list
``` 