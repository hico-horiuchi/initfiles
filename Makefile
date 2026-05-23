PWD=$(shell pwd)

install:
	asdf plugin list | grep -q awscli || asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git
	asdf plugin list | grep -q gcloud || asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud.git
	asdf plugin list | grep -q golang || asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
	asdf plugin list | grep -q nodejs || asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf plugin list | grep -q python || asdf plugin add python https://github.com/asdf-community/asdf-python.git
	asdf plugin list | grep -q ruby   || asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf plugin list | grep -q rust   || asdf plugin add rust https://github.com/asdf-community/asdf-rust.git

	ghq get github.com/b-ryan/powerline-shell
	cp $(PWD)/powerline-shell/k8s_namespace.py `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/segments/
	# patch `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/themes/default.py $(PWD)/powerline-shell/default_monterey.py.patch
	# patch `ghq root`/github.com/b-ryan/powerline-shell/powerline_shell/themes/default.py $(PWD)/powerline-shell/default_ventura.py.patch
	# cd `ghq root`/github.com/b-ryan/powerline-shell && ./setup.py build
	# cd `ghq root`/github.com/b-ryan/powerline-shell && ./setup.py install --user --prefix=

	ghq get github.com/hchbaw/auto-fu.zsh
	cd `ghq root`/github.com/hchbaw/auto-fu.zsh && git checkout pu

	ghq get github.com/justjanne/powerline-go
	# patch `ghq root`/github.com/justjanne/powerline-go/defaults.go $(PWD)/powerline-go/defaults_monterey.go.patch
	# patch `ghq root`/github.com/justjanne/powerline-go/defaults.go $(PWD)/powerline-go/defaults_ventura.go.patch
	grep -q "PS1=\$$'" `ghq root`/github.com/justjanne/powerline-go/defaults.go || \
		gsed -i -e "s|\`PS1=|\`PS1=$'\\\\n'|g" -e "s|\`PROMPT=|\`PROMPT=$'\\\\n'|g" `ghq root`/github.com/justjanne/powerline-go/defaults.go
	gsed -i 's|⎈ ||g' `ghq root`/github.com/justjanne/powerline-go/segment-kube.go
	# cd `ghq root`/github.com/justjanne/powerline-go && go build
	# mv `ghq root`/github.com/justjanne/powerline-go/powerline-go $(HOME)/.local/bin/

	ghq get github.com/skk-dev/dict
	mkdir -p $(HOME)/.local/share/yaskkserv2
	cd `ghq root`/github.com/skk-dev/dict && yaskkserv2_make_dictionary \
		--dictionary-filename=$(HOME)/.local/share/yaskkserv2/dictionary.yaskkserv2 \
		SKK-JISYO.L SKK-JISYO.jinmei SKK-JISYO.fullname SKK-JISYO.geo SKK-JISYO.propernoun SKK-JISYO.station
	cp skk/local.yaskkserv2.plist $(HOME)/Library/LaunchAgents/
	launchctl load -w $(HOME)/Library/LaunchAgents/local.yaskkserv2.plist || true

	ghq get github.com/cdalvaro/github-vscode-theme-iterm
	ghq get github.com/jimeh/tmux-themepack
	ghq get github.com/joshskidmore/zsh-fzf-history-search
	ghq get github.com/rupa/z
	ghq get github.com/scopatz/nanorc
	ghq get github.com/seebi/dircolors-solarized
	ghq get github.com/supercrabtree/k

	mkdir -p $(HOME)/.bundle
	mkdir -p $(HOME)/.claude
	mkdir -p $(HOME)/.config/gh
	mkdir -p $(HOME)/.config/gh-copilot
	mkdir -p $(HOME)/.config/powerline-shell
	mkdir -p $(HOME)/.copilot
	mkdir -p $(HOME)/.docker
	mkdir -p $(HOME)/.local/bin
	mkdir -p $(HOME)/Library/Application\ Support/Code/User/
	mkdir -p $(HOME)/Library/Application\ Support/lazygit

	ln -fns $(PWD)/asdf/asdfrc                       $(HOME)/.asdfrc
	ln -fns $(PWD)/asdf/default-cloud-sdk-components $(HOME)/.default-cloud-sdk-components
	ln -fns $(PWD)/asdf/default-gems                 $(HOME)/.default-gems
	ln -fns $(PWD)/asdf/default-npm-packages         $(HOME)/.default-npm-packages
	ln -fns $(PWD)/asdf/default-python-packages      $(HOME)/.default-python-packages
	ln -fns $(PWD)/bash/bashrc                       $(HOME)/.bashrc
	ln -fns $(PWD)/bash/inputrc                      $(HOME)/.inputrc
	ln -fns $(PWD)/bundle/config                     $(HOME)/.bundle/config
	ln -fns $(PWD)/claude/CLAUDE.md                  $(HOME)/.claude/CLAUDE.md
	ln -fns $(PWD)/claude/settings.json              $(HOME)/.claude/settings.json
	ln -fns $(PWD)/claude/statusline.sh              $(HOME)/.claude/statusline.sh
	ln -fns $(PWD)/docker/config.json                $(HOME)/.docker/config.json
	ln -fns $(PWD)/emacs/spacemacs                   $(HOME)/.spacemacs
	ln -fns $(PWD)/gem/gemrc                         $(HOME)/.gemrc
	ln -fns $(PWD)/git/gitconfig                     $(HOME)/.gitconfig
	ln -fns $(PWD)/git/gitignore                     $(HOME)/.gitignore
	ln -fns $(PWD)/git/templates                     $(HOME)/.git-templates
	ln -fns $(PWD)/github/gh_config.yml              $(HOME)/.config/gh/config.yml
	ln -fns $(PWD)/github/gh-copilot_config.yml      $(HOME)/.config/gh-copilot/config.yml
	ln -fns $(PWD)/github/copilot_config.json        $(HOME)/.copilot/config.json
	ln -fns $(PWD)/homebrew/Brewfile                 $(HOME)/.Brewfile
	ln -fns $(PWD)/lazygit/config.yml                $(HOME)/Library/Application\ Support/lazygit/config.yml
	ln -fns $(PWD)/nano/nanorc                       $(HOME)/.nanorc
	ln -fns $(PWD)/npm/npmrc                         $(HOME)/.npmrc
	ln -fns $(PWD)/powerline-shell/config.json       $(HOME)/.config/powerline-shell/config.json
	ln -fns $(PWD)/skk/yaskkserv2.conf               $(HOME)/.local/share/yaskkserv2/yaskkserv2.conf
	ln -fns $(PWD)/tmux/tmux.conf                    $(HOME)/.tmux.conf
	ln -fns $(PWD)/visual-studio-code/settings.json  $(HOME)/Library/Application\ Support/Code/User/settings.json
	ln -fns $(PWD)/wakatime/wakatime.cfg             $(HOME)/.wakatime.cfg
	ln -fns $(PWD)/zsh/zshrc                         $(HOME)/.zshrc

	# https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
	sudo cp macos/limit.max*.plist /Library/LaunchDaemons/
	sudo chown root:wheel /Library/LaunchDaemons/limit.max*.plist
	sudo chmod 644 /Library/LaunchDaemons/limit.max*.plist
	sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist || true
	sudo launchctl load -w /Library/LaunchDaemons/limit.maxproc.plist || true
