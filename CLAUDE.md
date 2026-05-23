# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

dotfiles / initfiles リポジトリ。macOS 環境のツール設定ファイルを一元管理し、`make install` でホームディレクトリへシンボリックリンクを張る構成。

## セットアップ

```bash
make install
```

`make install` は以下を実行する:

1. asdf プラグイン (awscli / gcloud / golang / nodejs / python / ruby / rust) を追加
2. gh extension、ghq 管理の外部リポジトリ (powerline-shell, auto-fu.zsh, powerline-go, skk-dict, etc.) をクローン
3. 各設定ファイルを `~/` へシンボリックリンクで配置
4. macOS の fd/proc 上限を上げる plist を `/Library/LaunchDaemons/` へコピー (sudo が必要)

## リポジトリ構造

各ディレクトリが 1 ツール = 1 設定ファイル群に対応する。シンボリックリンク先は Makefile の `ln -fs` 行で確認できる。

| ディレクトリ | リンク先 |
|---|---|
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline.sh` |
| `git/` | `~/.gitconfig`, `~/.gitignore`, `~/.git-templates/` |
| `zsh/` | `~/.zshrc` |
| `tmux/` | `~/.tmux.conf` |
| `visual-studio-code/` | `~/Library/Application Support/Code/User/settings.json` |
| `homebrew/` | `~/.Brewfile` |
| `asdf/` | `~/.asdfrc`, `~/.default-*` 各ファイル |
| `github/` | `~/.config/gh/config.yml`, `~/.config/gh-copilot/config.yml`, `~/.copilot/config.json` |
| `powerline-go/` | パッチファイル群 (Makefile で手動適用) |

## 主要ファイル

- **`Makefile`** — 唯一のエントリポイント。全シンボリックリンク定義と外部依存のクローン手順がある。
- **`git/gitconfig`** — `delta` をページャとして使用、`git graph` エイリアスあり、commit template に gitmoji 使用。
- **`zsh/zshrc`** — asdf / fzf / ghq / powerline-go / z / auto-fu.zsh / wakatime の統合、各種 fzf キーバインド (`^G^H` ghq, `^G^B` git branch, `^G^P` gh Pull Request, `^F` z) を定義。
- **`claude/settings.json`** — Claude Code の共有設定。サンドボックス有効、言語設定 `japanese`、Notification フックで `Glass.aiff` を再生。

## Claude Code 設定

`claude/settings.json` は `~/.claude/settings.json` にリンクされる共有設定で、`.claude/settings.json` (プロジェクトローカル) とは別物。

- `GIT_CONFIG_GLOBAL=""` を env に設定しており、Claude Code 実行中は `~/.gitconfig` のエイリアスが無効化される。
- 許可ドメイン: `github.com`, `api.github.com`, `raw.githubusercontent.com` のみ。
- `rm`, `sudo`, `curl`, `wget` の Bash 実行は deny されている。

## ファイルの更新

設定ファイルを編集した場合、シンボリックリンクのため即時反映される (再リンク不要)。  
新しいツール設定を追加する場合は `Makefile` に `mkdir -p` と `ln -fs` の行を追加する。

## コミット規約

`git/templates/commit_template` に gitmoji の一覧がコメントとして埋め込まれており、コミットメッセージの先頭に emoji を付ける慣習。  
テンプレートの再生成:

```bash
echo -e "\n" > git/templates/commit_template
curl -s https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json \
  | jq -r '.gitmojis[] | [.emoji, .code, .description] | @csv' \
  | sed -e 's/"//g' -e 's/^/# /g' -e 's/,:/ - :/g' -e 's/:,/: - /g' \
  >> git/templates/commit_template
```
