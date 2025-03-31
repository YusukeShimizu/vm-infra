# VSCodeからの接続

## 前提条件

1. VSCodeがインストールされていること
2. [Remote - SSH拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)がインストールされていること
3. SSH接続が設定済みであること（`docs/ssh-setup.md`参照）

## VSCodeでの接続手順

### 1. VSCodeの起動

Visual Studio Codeを起動します。

### 2. Remote-SSH拡張機能にアクセス

画面左下の緑色のアイコン（><）をクリックします。
これにより、リモート接続のためのメニューが表示されます。

### 3. ホストへの接続

1. 「Remote-SSH: Connect to Host...」を選択
2. 表示されるホスト一覧から `dev-vm` を選択
   - もし表示されない場合は、「Configure SSH Hosts...」を選択して設定ファイルを確認/編集
3. 初回接続時は、ホストの信頼性確認メッセージが表示されるので「Continue」を選択
4. 必要に応じてSSHパスフレーズを入力（パスフレーズを設定した場合）

### 4. リモート環境でのVSCodeの使用

接続が確立すると、VSCodeウィンドウがリモート環境用に切り替わります。
画面左下に「SSH: dev-vm」と表示されていれば、接続成功です。

## ファイルの操作

### リモートファイルのオープン

1. メニューから「File」>「Open Folder」を選択
2. リモートマシン上のディレクトリを選択（例: `/home/ubuntu/projects`）
3. 「OK」をクリックして開く

### ターミナルの使用

1. メニューから「Terminal」>「New Terminal」を選択
2. リモートマシン上でターミナルが開き、コマンドを実行できる

## 拡張機能の管理

リモート環境用の拡張機能をインストールできます：

1. 左側の拡張機能アイコンをクリック
2. インストールしたい拡張機能を検索
3. 「Install in SSH: dev-vm」ボタンをクリック

これにより、拡張機能はリモートマシン側にインストールされます。

## 開発ワークフロー

1. リモートフォルダを開く
2. コードの編集
3. ターミナルでコマンド実行（ビルド、テストなど）
4. Git操作（リモートマシンのGitクライアントを使用）

## 接続のトラブルシューティング

### 接続が切れる場合

接続が頻繁に切れる場合は、SSH設定に以下のオプションを追加してみてください：

```
Host dev-vm
  # ... 既存の設定 ...
  ServerAliveInterval 60
  ServerAliveCountMax 10
```

### リモートマシンに接続できない場合

1. IPアドレスとファイアウォール設定を確認
2. ローカルからSSH接続ができるか確認：`ssh dev-vm`
3. VSCodeのログを確認：「View」>「Output」を選択し、ドロップダウンから「Remote - SSH」を選択

### パフォーマンスの最適化

リモート接続が遅い場合：

1. コンプレッション設定の追加：
   ```
   Host dev-vm
     # ... 既存の設定 ...
     Compression yes
   ```

2. VSCodeの設定で「Remote.SSH: Remote Server Listen On Socket」を有効にする

## 接続の終了

VSCodeウィンドウを閉じるか、左下の接続アイコンをクリックして「Close Remote Connection」を選択することで接続を終了できます。

リモートVMのリソースを解放するため、使用しない場合は接続を閉じることをお勧めします。 