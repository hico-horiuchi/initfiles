PWD=$(shell pwd)

install:
	cd ~/.local || mkdir ~/.local

	cd $(HOME)/src && git clone git://github.com/hchbaw/auto-fu.zsh.git
	cd $(HOME)/src/auto-fu.zsh && git checkout -b pu origin/pu

	cd $(HOME)/src && git clone git://github.com/milkbikis/powerline-shell.git
	# patch $(HOME)/src/powerline-shell/powerline_shell/__init__.py $(PWD)/powerline-shell/powerline_shell_init.py.patch
	cd $(HOME)/src/powerline-shell && ./setup.py build && ./setup.py install --user

	cd $(HOME)/src && git clone git://github.com/jimeh/tmux-themepack.git
	cd $(HOME)/src && git clone git://github.com/supercrabtree/k.git
	cd $(HOME)/src && git clone git://github.com/rupa/z.git

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
