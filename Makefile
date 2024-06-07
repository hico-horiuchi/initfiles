PWD=$(shell pwd)

install:
	mkdir -p $(HOME)/.bundle
	mkdir -p $(HOME)/.config/powerline-shell
	mkdir -p $(HOME)/.docker
	mkdir -p $(HOME)/.local/bin

	ghq get github.com/b-ryan/powerline-shell
	# patch `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/themes/default.py $(PWD)/powerline-shell/default_monterey.py.patch
	# patch `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/themes/default.py $(PWD)/powerline-shell/default_ventura.py.patch
	cd `ghq root`/github.com/b-ryan/powerline-shell
	cp $(PWD)/powerline-shell/k8s_namespace.py powerline_shell/segments/
	./setup.py build
	./setup.py install --user --prefix=
	cd $(PWD)

	ghq get github.com/hchbaw/auto-fu.zsh
	cd `ghq root`/github.com/hchbaw/auto-fu.zsh && git checkout pu
	cd $(PWD)

	ghq get github.com/justjanne/powerline-go
	# patch `ghq root`/github.com/justjanne/powerline-go/defaults.go $(PWD)/powerline-go/defaults_monterey.go.patch
	# patch `ghq root`/github.com/justjanne/powerline-go/defaults.go $(PWD)/powerline-go/defaults_ventura.go.patch
	cd `ghq root`/github.com/justjanne/powerline-go
	gsed -i -e "s|\`PS1=|\`PS1=$'\\\\n'|g" -e "s|\`PROMPT=|\`PROMPT=$'\\\\n'|g" defaults.go
	gsed -i 's|⎈ ||g' segment-kube.go
	go build
	mv powerline-go $(HOME)/.local/bin/
	cd $(PWD)

	ghq get github.com/cdalvaro/github-vscode-theme-iterm
	ghq get github.com/jimeh/tmux-themepack
	ghq get github.com/joshskidmore/zsh-fzf-history-search
	ghq get github.com/rupa/z
	ghq get github.com/scopatz/nanorc
	ghq get github.com/seebi/dircolors-solarized
	ghq get github.com/supercrabtree/k

	ln -fs $(PWD)/asdf/asdfrc                       $(HOME)/.asdfrc
	ln -fs $(PWD)/asdf/default-cloud-sdk-components $(HOME)/.default-cloud-sdk-components
	ln -fs $(PWD)/asdf/default-gems                 $(HOME)/.default-gems
	ln -fs $(PWD)/asdf/default-npm-packages         $(HOME)/.default-npm-packages
	ln -fs $(PWD)/asdf/default-python-packages      $(HOME)/.default-python-packages
	ln -fs $(PWD)/bash/bashrc                       $(HOME)/.bashrc
	ln -fs $(PWD)/bash/inputrc                      $(HOME)/.inputrc
	ln -fs $(PWD)/bundle/config                     $(HOME)/.bundle/config
	ln -fs $(PWD)/docker/config.json                $(HOME)/.docker/config.json
	ln -fs $(PWD)/emacs/spacemacs                   $(HOME)/.spacemacs
	ln -fs $(PWD)/gem/gemrc                         $(HOME)/.gemrc
	ln -fs $(PWD)/git/gitconfig                     $(HOME)/.gitconfig
	ln -fs $(PWD)/git/gitignore                     $(HOME)/.gitignore
	ln -fs $(PWD)/git/templates                     $(HOME)/.git-templates
	ln -fs $(PWD)/homebrew/Brewfile                 $(HOME)/.Brewfile
	ln -fs $(PWD)/nano/nanorc                       $(HOME)/.nanorc
	ln -fs $(PWD)/powerline-shell/config.json       $(HOME)/.config/powerline-shell/config.json
	ln -fs $(PWD)/tmux/tmux.conf                    $(HOME)/.tmux.conf
	ln -fs $(PWD)/visual-studio-code/settings.json  $(HOME)/Library/Application\ Support/Code/User/settings.json
	ln -fs $(PWD)/wakatime/wakatime.cfg             $(HOME)/.wakatime.cfg
	ln -fs $(PWD)/zsh/zshrc                         $(HOME)/.zshrc

	# https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
	sudo cp macos/limit.max*.plist /Library/LaunchDaemons/
	sudo chown root:wheel /Library/LaunchDaemons/limit.max*.plist
	sudo chmod 644 /Library/LaunchDaemons/limit.max*.plist
	sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
	sudo launchctl load -w /Library/LaunchDaemons/limit.maxproc.plist

	gh extension install github/gh-copilot
