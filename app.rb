# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'erb'

# controller
class App < Sinatra::Application
  helpers do
    include ERB::Util
  end

  def to_utf8(text)
    text.force_encoding('utf-8')
  end

  def conn
    @conn = PG.connect(dbname: 'db_memos')
  end

  def read_memos
    conn.exec('SELECT * FROM memos ORDER BY id').map { |r| { 'id' => r['id'], 'title' => to_utf8(r['title']), 'memo' => to_utf8(r['memo']) } }
  end

  def read_memo(id)
    result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
    result.map { |r| { 'id' => r['id'], 'title' => to_utf8(r['title']), 'memo' => to_utf8(r['memo']) } }
  end

  def create_memo(title, memo)
    conn.exec_params('INSERT INTO memos (title = $1, memo = $2);', [title, memo])
  end

  def patch_memo(id, title, memo)
    conn.exec_params('UPDATE memos SET title = $1, memo = $2 WHERE id = $3;', [title, memo, id])
  end

  def delete_memo(id)
    conn.exec_params('DELETE from memos where id = $1;', [id])
  end

  get '/' do
    redirect '/memos'
  end

  get '/memos' do
    @memos = read_memos
    erb :top
  end

  get '/memos/new' do
    erb :new
  end

  post '/memos' do
    title = params[:title]
    memo = params[:memo]
    create_memo(title, memo)

    redirect '/memos'
  end

  get '/memos/:id' do
    memo = read_memo(params[:id])
    @title = memo[0]['title']
    @memo = memo[0]['memo']
    erb :show
  end

  get '/memos/:id/edit' do
    memos = read_memo(params[:id])
    @title = memos[0]['title']
    @memo = memos[0]['memo']
    erb :edit
  end

  patch '/memos/:id' do
    title = params[:title]
    memo = params[:memo]
    patch_memo(params[:id], title, memo)

    redirect "/memos/#{params[:id]}"
  end

  delete '/memos/:id' do
    delete_memo(params[:id])

    redirect '/memos'
  end
end
App.run!
