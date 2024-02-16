# PostgreSQLをインストールする
使用する依存関係パッケージをインストール
```
sudo apt install vim gnupg2 -y
```
リポジトリGPGキーをインポートする
```
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
```
PostgreSQLリポジトリを構成する
```
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```
PostgreSQL16パッケージをインストール
```
sudo apt install postgresql-16
```
## DBに接続できるか確認する
postgresqlのサービスを開始する
```
sudo systemctl start postgresql@16-main.service
```
サービスの状態を確認する（avtive(running)になっていたらOK）
```
systemctl status postgresql@16-main.service
```
ユーザーをpostgresに変更し、postgresに接続する
### DBを用意する

postgresユーザーのままpostgresDBの中で下記コマンドを実行し、postgresユーザーのままアプリを実行するか
```
CREATE DATABASE db_memos TEMPLATE = template0 ENCODING = 'UTF8';
```

普段操作しているユーザーにCREATEの権限を渡して以下を実行する
```
create database db_memos TEMPLATE = template0 ENCODING = 'UTF8'
```

## Gemをインストールする

terminalで下記を実行
```
bundler install
```
# アプリを動かす
terminalで下記を実行
```
bundle exec ruby app.rb
```

View at: http://localhost:4567

## rubocopの設定

`rubocop-fjord`をインストールした上で`.rubocop.yml`に下記の設定を追加する。

```yml
inherit_gem:
  rubocop-fjord:
    - "config/rubocop.yml"
```
## rubocopを実行

terminalで下記を実行

```zsh
% rubocop
```
## erblintの設定
`.erb-lint.yml` を以下の内容でプロジェクトのルートに作成する。

```yaml
---
glob: "**/*.erb"
linters:
  RequireInputAutocomplete:
    enabled: false
```
## erblintを実行

terminalで下記を実行

```sh
$ bundle exec erblint --lint-all
```
