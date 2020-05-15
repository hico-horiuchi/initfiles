PWD=$(shell pwd)

install:
	mkdir -p ~/.local
	mkdir -p ~/.config/powerline-shell

	ghq get github.com/hchbaw/auto-fu.zsh
	cd `ghq root`/github.com/hchbaw/auto-fu.zsh && git checkout -b pu origin/pu

	ghq get github.com/banga/powerline-shell
	# patch $(HOME)/src/powerline-shell/powerline_shell/__init__.py $(PWD)/powerline-shell/powerline_shell_init.py.patch
	cd `ghq root`/github.com/banga/powerline-shell && ./setup.py build && ./setup.py install --user --prefix=

	ghq get github.com/jimeh/tmux-themepack
	ghq get github.com/supercrabtree/k
	ghq get github.com/rupa/z

	sudo pip install wakatime

	ln -fs $(PWD)/bash/bashrc                        $(HOME)/.bashrc
	ln -fs $(PWD)/bash/inputrc                       $(HOME)/.inputrc
	ln -fs $(PWD)/emacs/spacemacs                    $(HOME)/.spacemacs
	ln -fs $(PWD)/gem/gemrc                          $(HOME)/.gemrc
	ln -fs $(PWD)/git/gitconfig                      $(HOME)/.gitconfig
	ln -fs $(PWD)/git/gitignore                      $(HOME)/.gitignore
	ln -fs $(PWD)/git/commit_template                $(HOME)/.commit_template
	ln -fs $(PWD)/homebrew/Brewfile                  $(HOME)/.Brewfile
	ln -fs $(PWD)/powerline-shell/powerline-shell.py $(HOME)/.powerline-shell.json
	ln -fs $(PWD)/powerline-shell/config.json        $(HOME)/.config/powerline-shell/config.json
	ln -fs $(PWD)/tmux/tmux.conf                     $(HOME)/.tmux.conf
	ln -fs $(PWD)/zsh/zshrc                          $(HOME)/.zshrc
	ln -fs $(PWD)/wakatime/wakatime.cfg              $(HOME)/.wakatime.cfg
