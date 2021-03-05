## :books: initfiles

### git/templates/commit_template

```
echo -e "\n" > git/templates/commit_template
curl -s https://gitmoji.dev/ \
  | sed 's|</p>|\n&|g' \
  | xmllint --html --xpath '//article/div/header/button/text()|//article/div/div/button/code/text()|//article/div/div/p/text()' - 2> /dev/null \
  | sed -e 's/^/# /g' -e 's/\(:\w*:\)/ - \1 - /g' >> git/templates/commit_template
```
