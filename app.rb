# frozen_string_literal: true

require 'sinatra'
require 'json'

enable :method_override
FILE_PATH = 'memos.json'

def get_memos
  File.open(FILE_PATH) { |f| JSON.parse(f.read) }
end

def set_memos(memos)
  File.open(FILE_PATH,'w') { |f| JSON.dump(memos, f) }
end

end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = get_memos
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :show
end

post '/memos' do
  title = params[:title]
  memo = params[:memo]

  memos = get_memos
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'memo' => memo }
  set_memos(memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos
  @title = memos[params[:id]]['title']
  @memo = memos[params[:id]]['memo']
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  memo = params[:memo]

  memos = get_memos
  memos[params[:id]] = { 'title' => title, 'memo' => memo }
  set_memos(memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos
  memos.delete(params[:id])
  set_memos(memos)

  redirect '/memos'
end
