PWD=$(shell pwd)

install:
	ln -fs $(PWD)/bash/bashrc    $(HOME)/.bashrc
	ln -fs $(PWD)/bash/inputrc   $(HOME)/.inputrc
	ln -fs $(PWD)/gem/gemrc      $(HOME)/.gemrc
	ln -fs $(PWD)/git/gitconfig  $(HOME)/.gitconfig
	ln -fs $(PWD)/git/gitignore  $(HOME)/.gitignore
	cd $(HOME)/src && git clone git://github.com/mooz/percol.git
	python $(HOME)/src/percol/setup.py install --prefix=$(HOME)/.local
	cd $(HOME)/.percol.d || mkdir $(HOME)/.percol.d
	ln -fs $(PWD)/percol/rc.py   $(HOME)/.percol.d/rc.py
	ln -fs $(PWD)/tmux/tmux.conf $(HOME)/.tmux.conf
	cd $(HOME)/src && git clone git://github.com/hchbaw/auto-fu.zsh.git
	cd $(HOME)/src/auto-fu.zsh && git checkout -b pu origin/pu
	cd $(HOME)/src && git clone git://github.com/milkbikis/powerline-shell.git
	$(HOME)/src/powerline-shell/install.py
	ln -fs $(PWD)/zsh/zshrc      $(HOME)/.zshrc
