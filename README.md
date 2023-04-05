## :books: initfiles

### git/templates/commit_template

```
echo -e "\n" > git/templates/commit_template
curl -s https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json \
  | jq -r '.gitmojis[] | [.emoji, .code, .description] | @csv' \
  | sed -e 's/"//g' -e 's/^/# /g' -e 's/,:/ - :/g' -e 's/:,/: - /g' \
  >> git/templates/commit_template
```
