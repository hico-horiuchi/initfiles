PWD=$(shell pwd)

install:
	cd ~/.local || mkdir ~/.local

	cd $(HOME)/src && git clone git://github.com/mooz/percol.git
	cd $(HOME)/src/percol && python setup.py install --prefix=~/.local
	cd $(HOME)/.percol.d || mkdir $(HOME)/.percol.d

	cd $(HOME)/src/solarized && mkdir $(HOME)/src/solarized
	cd $(HOME)/src/solarized && wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark

	cd $(HOME)/src && git clone git://github.com/hchbaw/auto-fu.zsh.git
	cd $(HOME)/src/auto-fu.zsh && git checkout -b pu origin/pu

	cd $(HOME)/src && git clone git://github.com/milkbikis/powerline-shell.git
	patch $(HOME)/src/powerline-shell/powerline_shell_base.py $(PWD)/powerline-shell/powerline_shell_base.py.patch
	cd $(HOME)/src/powerline-shell && ./install.py

	cd $(HOME)/src && git clone git://github.com/supercrabtree/k.git
	cd $(HOME)/src && git clone git://github.com/rupa/z.git

	sudo pip install wakatime

	ln -fs $(PWD)/bash/bashrc           $(HOME)/.bashrc
	ln -fs $(PWD)/bash/inputrc          $(HOME)/.inputrc
	ln -fs $(PWD)/gem/gemrc             $(HOME)/.gemrc
	ln -fs $(PWD)/git/gitconfig         $(HOME)/.gitconfig
	ln -fs $(PWD)/git/gitignore         $(HOME)/.gitignore
	ln -fs $(PWD)/git/commit_template   $(HOME)/.commit_template
	ln -fs $(PWD)/percol/rc.py          $(HOME)/.percol.d/rc.py
	ln -fs $(PWD)/tmux/tmux.conf        $(HOME)/.tmux.conf
	ln -fs $(PWD)/zsh/zshrc             $(HOME)/.zshrc
	ln -fs $(PWD)/wakatime/wakatime.cfg $(HOME)/.wakatime.cfg
