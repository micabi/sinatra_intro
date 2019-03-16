require 'rubygems'
require 'bundler'
Bundler.require

## データベースの指定

set :database, {adapter: "sqlite3", database: "contacts.sqlite3"}

## セッションを有効化
enable :sessions


## モデル(テーブル名とバリデーション)

class Contact < ActiveRecord::Base
  validates_presence_of :name
end

## コントローラー

get '/' do
  @now = Time.now
  #"Hello World! Time is #{ now }"
  @contacts = Contact.all
  @message = session[:message]
  #@message = session.delete :message
  erb :index
end

get '/contact_new' do
  @contact = Contact.new
  erb :contact_new
end

post '/contacts' do
  puts "=== 送信されたデータ ==="
  #puts params

  # postされたデータの取り出し
  name = params[:name]
  puts name

  # DBへの保存
  @contact = Contact.new({name: name})
  if @contact.save
    session[:message] = "#{name}さんを追加しました。"
    redirect '/' # topにリダイレクト
  else
    erb :contact_new # フォームを再度表示する
  end

end