## Gemをインストールする

terminalで下記を実行
```
bundler install
```
### アプリを動かす
terminalで下記を実行
```
bundle exec ruby app.rb
```

View at: http://localhost:4567

### 設定

`rubocop-fjord`をインストールした上で`.rubocop.yml`に下記の設定を追加する。

```yml
inherit_gem:
  rubocop-fjord:
    - "config/rubocop.yml"
```
## rubocopの実行

terminalで下記を実行

```zsh
% rubocop
```

`.erb-lint.yml` を以下の内容でプロジェクトのルートに作成する。

```yaml
---
glob: "**/*.erb"
linters:
  RequireInputAutocomplete:
    enabled: false
```
## 実行

terminalで下記を実行

```sh
$ bundle exec erblint --lint-all
```
