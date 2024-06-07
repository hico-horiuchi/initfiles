## :books: initfiles

### git/templates/commit_template

```
echo -e "\n" > git/templates/commit_template
curl -s https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json \
  | jq -r '.gitmojis[] | [.emoji, .code, .description] | @csv' \
  | sed -e 's/"//g' -e 's/^/# /g' -e 's/,:/ - :/g' -e 's/:,/: - /g' \
  >> git/templates/commit_template
```

### terminal/dircolors.256dark

```
curl -s -o terminal/dircolors.256dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
```
