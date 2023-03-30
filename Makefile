PWD=$(shell pwd)

install:
	mkdir -p ~/.config/powerline-shell
	mkdir -p ~/.local

	ghq get github.com/b-ryan/powerline-shell
	# patch `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/__init__.py $(PWD)/powerline-shell/powerline_shell_init.py.patch
	cd `ghq root`/github.com/b-ryan/powerline-shell && cp $(PWD)/powerline-shell/k8s_namespace.py powerline_shell/segments/ && ./setup.py build && ./setup.py install --user --prefix=

	ghq get github.com/hchbaw/auto-fu.zsh
	cd `ghq root`/github.com/hchbaw/auto-fu.zsh && git checkout pu

	ghq get github.com/jimeh/tmux-themepack
	ghq get github.com/rupa/z
	ghq get github.com/scopatz/nanorc
	ghq get github.com/supercrabtree/k

	pip install -U iterm2 pip setuptools 'wakatime==13.1.0'

	ln -fs $(PWD)/bash/bashrc                        $(HOME)/.bashrc
	ln -fs $(PWD)/bash/inputrc                       $(HOME)/.inputrc
	ln -fs $(PWD)/emacs/spacemacs                    $(HOME)/.spacemacs
	ln -fs $(PWD)/gem/gemrc                          $(HOME)/.gemrc
	ln -fs $(PWD)/git/gitconfig                      $(HOME)/.gitconfig
	ln -fs $(PWD)/git/gitignore                      $(HOME)/.gitignore
	ln -fs $(PWD)/git/templates                      $(HOME)/.git-templates
	ln -fs $(PWD)/homebrew/Brewfile                  $(HOME)/.Brewfile
	ln -fs $(PWD)/nano/nanorc                        $(HOME)/.nanorc
	ln -fs $(PWD)/powerline-shell/config.json        $(HOME)/.config/powerline-shell/config.json
	ln -fs $(PWD)/tmux/tmux.conf                     $(HOME)/.tmux.conf
	ln -fs $(PWD)/zsh/zshrc                          $(HOME)/.zshrc
	ln -fs $(PWD)/wakatime/wakatime.cfg              $(HOME)/.wakatime.cfg
