# Git/GitHub の使用方法

開発VMにはGitとGitHub CLI (gh)がプリインストールされています。以下は基本的な使用方法です。

## GitHub へのログイン

GitHub CLI (gh) を使用してGitHubアカウントにログインします：

```bash
gh auth login
```

プロンプトに従って認証情報を入力します：
1. GitHub.comを選択
2. HTTPS接続を選択
3. Web browserを使った認証方法を選択
4. 表示されるコードをブラウザで入力

## リポジトリのクローン

### GitHub CLIでクローン

```bash
# GitHub CLIを使用してリポジトリをクローン
gh repo clone owner/repository

# 例：
gh repo clone yourusername/your-project
```

### 通常のGitでクローン

```bash
# HTTPSでクローン
git clone https://github.com/owner/repository.git

# SSHでクローン (SSH鍵設定済みの場合)
git clone git@github.com:owner/repository.git
```

## ブランチの作成と切り替え

```bash
# 新しいブランチを作成して切り替え
git checkout -b feature/new-feature

# 既存のブランチに切り替え
git checkout main
```

## 変更の追加とコミット

```bash
# 変更ファイルの確認
git status

# 特定のファイルを追加
git add filename.js

# すべての変更を追加
git add .

# コミット
git commit -m "変更内容の説明"
```

## 変更のプッシュ

```bash
# リモートリポジトリに変更をプッシュ
git push origin branch-name

# 例：
git push origin feature/new-feature
```

## プルリクエストの作成

```bash
# GitHub CLIでプルリクエスト作成
gh pr create --title "プルリクエストのタイトル" --body "変更内容の説明"
```

または、GitHubのWebインターフェースから「Pull requests」タブを開き、「New pull request」をクリックします。

## リポジトリの更新

```bash
# リモートの変更を取得
git fetch origin

# 変更を取り込む
git pull origin main
```

## よくあるGitワークフロー

1. リポジトリをクローン: `git clone [URL]`
2. 新しいブランチを作成: `git checkout -b feature/new-feature`
3. 変更を加える
4. 変更を追加: `git add .`
5. 変更をコミット: `git commit -m "メッセージ"`
6. 変更をプッシュ: `git push origin feature/new-feature`
7. プルリクエストを作成: `gh pr create`
8. レビュー後にマージ

## Gitの設定

初めてGitを使用する場合は、ユーザー情報を設定する必要があります：

```bash
git config --global user.name "あなたの名前"
git config --global user.email "your.email@example.com"
```

## .gitignoreの作成

特定のファイルやディレクトリをGitの管理対象から除外するには、`.gitignore`ファイルを作成します：

```bash
# .gitignoreファイルの作成
touch .gitignore

# エディタで開いて除外パターンを追加
vi .gitignore
```

一般的な.gitignoreの例：
```
# 一時ファイル
*.tmp
*.log

# ビルドディレクトリ
/dist
/build
/node_modules

# 環境設定ファイル
.env
.env.local

# エディタ固有のファイル
.vscode/
.idea/
``` 