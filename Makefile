PWD=$(shell pwd)

clean:
	rm -f $(HOME)/.bashrc
	rm -f $(HOME)/.inputrc
	rm -f $(HOME)/.gemrc
	rm -f $(HOME)/.gitconfig
	rm -f $(HOME)/.gitignore
	rm -f $(HOME)/.percol.d/rc.py
	rm -f $(HOME)/.tmux.conf
	rm -f $(HOME)/.zshrc

install:
	ln -fs ${PWD}/bash/bashrc    $(HOME)/.bashrc
	ln -fs ${PWD}/bash/inputrc   $(HOME)/.inputrc
	ln -fs ${PWD}/gem/gemrc      $(HOME)/.gemrc
	ln -fs ${PWD}/git/gitconfig  $(HOME)/.gitconfig
	ln -fs ${PWD}/git/gitignore  $(HOME)/.gitignore
	ln -fs ${PWD}/percol/rc.py   $(HOME)/.percol.d/rc.py
	ln -fs ${PWD}/tmux/tmux.conf $(HOME)/.tmux.conf
	ln -fs ${PWD}/zsh/zshrc      $(HOME)/.zshrc
