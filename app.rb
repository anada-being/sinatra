# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'erb'

# controller
class App < Sinatra::Application
  @conn = PG.connect(dbname: 'db_memos')

  helpers do
    include ERB::Util
  end

  configure do
    @conn.exec('create table IF NOT EXISTS memos (id serial, title TEXT, memo TEXT)')
  end

  def self.to_utf8(text)
    text.force_encoding('utf-8')
  end

  def self.read_memos
    @conn.exec('SELECT * FROM memos ORDER BY id').map { |r| { id: r['id'], title: App.to_utf8(r['title']), memo: App.to_utf8(r['memo']) } }
  end

  def self.read_memo(id)
    result = @conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
    { id: result[0]['id'], title: App.to_utf8(result[0]['title']), memo: App.to_utf8(result[0]['memo']) }
  end

  def self.create_memo(title, memo)
    @conn.exec_params('INSERT INTO memos (title, memo) VALUES ($1, $2);', [title, memo])
  end

  def self.patch_memo(id, title, memo)
    @conn.exec_params('UPDATE memos SET title = $1, memo = $2 WHERE id = $3;', [title, memo, id])
  end

  def self.delete_memo(id)
    @conn.exec_params('DELETE from memos where id = $1;', [id])
  end

  get '/' do
    redirect '/memos'
  end

  get '/memos' do
    @memos = App.read_memos
    erb :top
  end

  get '/memos/new' do
    erb :new
  end

  post '/memos' do
    title = params[:title]
    memo = params[:memo]
    App.create_memo(title, memo)

    redirect '/memos'
  end

  get '/memos/:id' do
    memo = App.read_memo(params[:id])
    @title = memo[:title]
    @memo = memo[:memo]
    erb :show
  end

  get '/memos/:id/edit' do
    memos = App.read_memo(params[:id])
    @title = memos[:title]
    @memo = memos[:memo]
    erb :edit
  end

  patch '/memos/:id' do
    title = params[:title]
    memo = params[:memo]
    App.patch_memo(params[:id], title, memo)

    redirect "/memos/#{params[:id]}"
  end

  delete '/memos/:id' do
    App.delete_memo(params[:id])

    redirect '/memos'
  end
end
App.run!
