# CLAUDE.md

macOS 環境のツール設定ファイルを管理する dotfiles リポジトリ。`Makefile` が唯一のエントリポイントで、`make install` がホームディレクトリへシンボリックリンクを張る。

## 検証

- `make install` は `sudo` を含むため Claude は実行せず、`make -n install` で手順を確認する
- `herdr/config.toml` の編集後は、ユーザーが `herdr config check` で検証し、`herdr server reload-config` で再読み込みする
  - `herdr config check` は sandbox 内で `Operation not permitted` になる

## 注意点

- シンボリックリンク先はメインの checkout のため、worktree での編集はメインの checkout へマージするまで反映されない
- `Makefile` は `$(PWD)` からリンク先を決めるため、worktree で `make install` を実行しない
- `claude/settings.json` は `~/.claude/settings.json` にリンクされる共有設定で、`.claude/settings.json` (プロジェクトローカル) とは別物
- `claude/settings.json` が `GIT_CONFIG_GLOBAL=""` を設定するため、Claude Code 実行中は `~/.gitconfig` のエイリアス / commit template / pager が無効になる

## 新しいツール設定の追加

`Makefile` に `mkdir -p` と `ln -fns` の行を追加する。

## コミット規約

- 件名は `fix herdr-gpui settings` のような英語の短文で書き、gitmoji は付けない
- `git/templates/commit_template` の再生成手順は `README.md` に従う
  - 手順内の `curl` は Bash で deny されているため、ユーザーが実行する
