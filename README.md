# Gemfile を作成
 bundle init
## Gemをインストールする

Gemfileに下記を追記する
```
group :development do
  gem 'rubocop-fjord', require: false
end

gem 'sinatra'
gem 'puma' # or any other server
gem 'redcarpet'
gem 'erb_lint', require: false
```
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

```sh
$ bundle exec erblint --lint-all
```
