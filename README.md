# sinatra

install the gem:
```
gem install sinatra
gem install puma # or any other server
```
And run with:
```
ruby app.rb
```

View at: http://localhost:4567

# rubocop-fjord

rubocop-fjord is a rubocop configuration from Fjord, Inc.

## rubocopのインストール

Gemfileに下記を追記する

```ruby
# For plain Ruby scripts
group :development do
  gem 'rubocop-fjord', require: false
end
```

そして、以下を実行します。
$ bundle
または、次のように自分でインストールします。
$ gem install rubocop-fjord

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

## erb_lintのインストール

```bash
gem install erb_lint
```

... 上記を実行するか`Gemfile`に下記を追記して`bundle install`を実行する:

```ruby
gem 'erb_lint', require: false
```
## 設定

### Sinatra

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
