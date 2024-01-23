# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'cgi'

enable :method_override
FILE_PATH = 'memos.json'

def read_memos
  File.open(FILE_PATH) { |f| JSON.parse(f.read) }
end

def save_memos(memos)
  File.open(FILE_PATH, 'w') { |f| JSON.dump(memos, f) }
end

def escape(text)
  CGI.escapeHTML(text)
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

get '/memos/:id' do
  memos = read_memos
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :show
end

post '/memos' do
  title = escape(params[:title])
  memo = escape(params[:memo])

  memos = read_memos
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'memo' => memo }
  save_memos(memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = read_memos
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :edit
end

patch '/memos/:id' do
  title = escape(params[:title])
  memo = escape(params[:memo])

  memos = read_memos
  memos[params[:id]] = { 'title' => title, 'memo' => memo }
  save_memos(memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = read_memos
  memos.delete(params[:id])
  save_memos(memos)

  redirect '/memos'
end
