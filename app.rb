require 'rubygems'
require 'bundler'
Bundler.require

## データベースの指定

set :database, {adapter: "sqlite3", database: "contacts.sqlite3"}

## モデル

class Contact < ActiveRecord::Base
  validates_presence_of :name
end

## コントローラー

get '/' do
  @now = Time.now
  #"Hello World! Time is #{ now }"
  erb :index
end

get '/contact_new' do
  erb :contact_form
end

post '/contacts' do
  puts "=== 送信されたデータ ==="
  #puts params

  # postされたデータの取り出し
  name = params[:name]
  puts name

  # DBへの保存
  contact = Contact.new({name: name})
  contact.save

  # リダイレクト
  redirect '/'
end