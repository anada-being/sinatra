# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

enable :method_override
FILE_PATH = 'memos.json'

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :show
end

post '/memos' do
  title = params[:title]
  memo = params[:memo]

  memos = get_memos(FILE_PATH)
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'memo' => memo }
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  memo = params[:memo]

  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'memo' => memo }
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end