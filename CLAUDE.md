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
2. gh extension、ghq 管理の外部リポジトリ (auto-fu.zsh, powerline-go, powerline-shell, skk-dict, etc.) をクローン
3. 各設定ファイルを `~/` へシンボリックリンクで配置
4. `herdr integration install claude` で herdr の agent 状態検知フックを導入
5. macOS の fd/proc 上限を上げる plist を `/Library/LaunchDaemons/` へコピー (sudo が必要)

## リポジトリ構造

各ディレクトリが 1 ツール = 1 設定ファイル群に対応する。シンボリックリンク先は Makefile の `ln -fs` 行で確認できる。

| ディレクトリ | リンク先 |
|---|---|
| `asdf/` | `~/.asdfrc`, `~/.default-*` 各ファイル |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline.sh` |
| `git/` | `~/.gitconfig`, `~/.gitignore`, `~/.git-templates/` |
| `github/` | `~/.config/gh/config.yml`, `~/.config/gh-copilot/config.yml`, `~/.copilot/config.json` |
| `herdr/` | `~/.config/herdr/config.toml` |
| `homebrew/` | `~/.Brewfile` |
| `lazygit/` | `~/Library/Application Support/lazygit/config.yml` |
| `powerline-go/` | パッチファイル群 (Makefile で手動適用) |
| `tmux/` | `~/.tmux.conf` |
| `visual-studio-code/` | `~/Library/Application Support/Code/User/settings.json` |
| `zsh/` | `~/.zshrc` |

## 主要ファイル

- **`claude/settings.json`** — サンドボックス有効、言語設定 `japanese`、herdr の agent 状態検知フックを含む Claude Code の共有設定
- **`git/gitconfig`** — `delta` をページャとして使用し、`git graph` エイリアスと gitmoji の commit template を設定
- **`herdr/config.toml`** — Claude Code 用のターミナルワークスペース管理ツール herdr の設定で、prefix や分割キーを `tmux/tmux.conf` に揃え、テーマは catppuccin を Light/Dark 自動切り替えで使う (`herdr config check` で検証、`herdr server reload-config` で再読み込み)
- **`zsh/zshrc`** — asdf / auto-fu.zsh / fzf / ghq / powerline-go / wakatime / z の統合と各種 fzf キーバインド (`^F` z, `^G^B` git branch, `^G^H` ghq, `^G^P` gh Pull Request) を定義
- **`Makefile`** — 唯一のエントリポイントであり、全シンボリックリンク定義と外部依存のクローン手順を持つ

## Claude Code 設定

`claude/settings.json` は `~/.claude/settings.json` にリンクされる共有設定で、`.claude/settings.json` (プロジェクトローカル) とは別物。

- `curl`, `rm`, `sudo`, `wget` の Bash 実行は deny されている
- `GIT_CONFIG_GLOBAL=""` を env に設定しており、Claude Code 実行中は `~/.gitconfig` のエイリアスが無効化される
- 許可ドメインは `api.github.com`, `gist.github.com`, `github.com`, `raw.githubusercontent.com` のみ

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
