# 作業用のディレクトリを作成する

@terminal
```
$ mkdir sinatra
$ cd sinatra
$ touch app.rb
```

## コンソールに文字列を出力してみる

@terminal
```
$ ruby app.rb
```

# sinatraをインストールする

@cosole
```
$ gem install -N sinatra
$ gem install -N sinatra-reloader
```
オプション -N（--no-ri --no-rdoc）  ドキュメントなしでインストール


## siantraをアプリから読み込む

インストールしたgem(sinatraとsinatra-reloader)をアプリで使うためにapp.rbの先頭に記述する。

@app.rb
```
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  now = Time.now
  "Hello World! Time is #{ now }"
end
```

@terminal

```
$ ruby app.rb

[2019-03-11 23:29:28] INFO  WEBrick 1.4.2
[2019-03-11 23:29:28] INFO  ruby 2.5.0 (2017-12-25) [i686-linux]
== Sinatra (v2.0.5) has taken the stage on 4567 for development with backup from WEBrick
[2019-03-11 23:29:28] INFO  WEBrick::HTTPServer#start: pid=15682 port=4567
```

## htmlのテンプレートを用意する

「views」というディレクトリを作成する（重要！）
>sinatraではテンプレートファイルの場所は「views」にするという規約がある。

@terminal
```
$ mkdir views
$ cd views
$ touch index.erb
```

現在のディレクトリ構造

```
├── app.rb
└── views
    └── index.erb
```


@index.erb

```
<!doctype>
<html lang="ja">
...
<p>今の時刻: <%= @now %>です。</p>
...
<html>
```

> 変数nowに@をつけるとviwes/index.erbから参照できる変数となる<br><br>
>erb :indexとすることで/にアクセスされたらindex.erbが表示される（呼び出される）ようになる。<br><br>
>テンプレート（views/***.erb）からapp.rbで定義した変数を呼び出す場合は
<%=  %>で挟む。

@app.rb

```
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @now = Time.now
  erb :index ### views/index.erbを表示
end
```

## 静的ファイルを呼び出す

「public」というディレクトリを作成する（重要！）

>sinatraでは静的ファイルの場所は「public」>にするという規約がある。
>「public」にはcssの他、通常のhtmlファイル>で変数を使わないページをおくこともできる。

@terminal
```
$ mkdir public
$ cd public
$ touch style.css
```

現在のディレクトリ構造
```
├── app.rb
├── public
│   └── style.css
└── views
    └── index.erb
```

---

## フォーム(POST通信)を使う

```
$ cd views
$ touch contact_form.erb
```
現在のディレクトリ構造
```
├── app.rb
├── public
│   ├── about.html
│   └── style.css
└── views
    ├── contact_form.erb
    └── index.erb
```

@contact_form.erb
```
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>新規ユーザーの追加</title>
</head>
<body>
  <h1>新規ユーザーの追加</h1>
  <form action="" method="post">
    <input type="text" name="name" id="">
    <input type="submit" value="送信">
  </form>
  <div><a href="/">戻る</a></div>
</body>
</html>
```

## テンプレートを作っただけじゃ表示ができない！！

>sinatraではテンプレートを作ったら、そのerbファイルをどのようなurlがリクエストがきたときに表示してやるのかをapp.rbに書いてやる必要がある。
>app.rbはコントローラーの役割がある。

```
$ vim app.rb
```

@app.rb

```
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @now = Time.now
  #"Hello World! Time is #{ now }"
  erb :index
end

get '/contact_new' do  ## フォームのページ
  erb :contact_form  ## ここではurlとファイル名を変えたが同じでも良い。
end
```

@app.rb
```
get '/contact_new' do  ## フォームのページ
  erb :contact_form
end


post '/contacts' do
  puts params  ## postされたデータはparamsで受け取る

  redirect '/'  ## topへリダイレクト
end
```
>テンプレートviews/contact_form.rbからpostされた送信先としてcontactsというurlを指定しているが、表示は必要ない処理なのでviewを作っていないことに注目！！



<br>

# gemをbundlerを使って管理する

ここまではgemが必要なときに都度、gem install ○○とコマンドを打ってインストールしたが、必要なgemが増えると管理が難しくなる。
そこで、gemを管理するためのgem「bundler」を使って管理する。

## インストール

@terminal

```
$ gem install bundler
```

インストールできたら次は管理につかうGemfileを作成する。

## Gemfileを作成

@terminal

```
$ bundle init
```

Gemfileができた。

```
├── Gemfile
├── app.rb
├── public
│   ├── about.html
│   └── style.css
└── views
    ├── contact_form.erb
    └── index.erb
```

<br>

## Gemfileの書き方

app.rbの先頭に書いてあったgemをGemfileに移す。
* require 'sinatra'
* require 'sinatra/reloader'

@app.rb
```
require 'sinatra'  ## ここを切り取り
require 'sinatra/reloader'  ## ここを切り取り

get '/' do
  @now = Time.now
...
```

コピペして書き換える。

@Gemfile
```
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem 'sinatra'   ## こう書く
gem 'sinatra-reloader'   ## こう書く
```

そして、gemをGemfileに記述したものから呼び出すように、という命令をapp.rbの先頭に書く。

@app.rb
```
require 'rubygems'  ## この
require 'bundler'   ## 3行を
Bundler.require   ## 追記


get '/' do
  @now = Time.now
...
```

これでgemの管理をGemfileを通してできる環境が整った。

## あらためてGemfileからgemをインストールする

@terminal
```
$ bundle install --path vendor/bundle
```

>オプション --path vendor/bundle

インストールしたgemをvendorというディレクトリで管理するよ、ということ。

>Gemfileとはアプリで使うgem一覧のようなもの

## アプリを起動してみる

>bundleを使ってgemをインストールすると起動コマンドが変わる。(先頭にbundle execをつける)

@terminal
```
$ bundle exec ruby app.rb
```

---

## データベースを用意する

sinatraでデータベースを使うにはgemのsinatra-activerecordを使う。

### Gemfileにgemを追加する

>[Sinatra ActiveRecord ドキュメント](https://github.com/janko/)

@Gemfile
```
...
gem "sinatra-activerecord"
gem "sqlite3"
gem "rake"
```

### app.rbとsqlite3を使ったデータベースを紐付ける

app.rbに追記する

@app.rb
```
set :database, {adapter: "sqlite3", database: "contacts.sqlite3"}  ## ***.sqlite3はファイル名
```

### Rakefileを作成する

>さきほどインストールしたgem 'rake(ruby-make)'は、rubyで定型的な処理をさせるためのもの。シェルスクリプトの.shファイルみたいなもの。

RakefileはRubyで書かれたタスクを定義するファイル。

@terminal
```
$ touch Rakefile
```
ディレクトリ構成
```
├── Rakefile
├── Gemfile
├── app.rb
├── public
│   ├── about.html
│   └── style.css
└── views
│   ├── contact_form.erb
│   └── index.erb
└── vendor
    └── bundle
        └──...
```
@Rakefile
```
require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./app"   ## app.rbにひも付け
  end
end
```

>rakefile（rakeコマンド）自体はデータベースを作成するためだけの専用コマンドではない。

インストールしてあるgem 'sinatra-activerecord'に入っているrakeモジュールを読み込み(require)、:dbという名前をつけてある機能の設定を読み込め、というようなことが書いてある。実際にはこれを実行(bundle exec rake -T)すると、

1. rake db:create_migration
2. rake db:migrate
3. rake db:rollback

の3つのコマンドが使えるようになる。


### Rakefileを実行する

@terminal
```
$ bundle exec rake -T
```
>オプション -T(--task) タスクを実行する。

ここまでで、

* app.rb用のデータベースができた
* db名はcontacts
* まだ中身は空っぽ（テーブルもデータもカラムもない）




---

## テーブルを作成する

### 1. マイグレーションファイルを作成する

>マイグレーションファイルとは
データベースのテーブル構造(テーブルやカラムの追加・削除・編集）の変更内容をテキストベースで管理するためのファイル。※本番環境のデータベースを直接操作するものではない。

@terminal
```
$ bundle exec rake db:create_migration NAME=contacts_users
```

#### マイグレーションファイルの生成
>$ bundle exec rake db:create_migration NAME=***

'contact_users.rb'という名前のマイグレーションファイルが作成される。

※dbディレクトリが新たに作成され、その中にschema.rbファイルと、migrateディレクトリが入った状態になる。

```
├── Rakefile
├── Gemfile
├── app.rb
├── public
│   ├── about.html
│   └── style.css
├── views
│   ├── contact_form.erb
│   └── index.erb
├── vendor
│    └── bundle
│        └──...
└── db
   ├── schema.rb
   └── migrate
        └──contact_users.rb
```



@db/migrate/xxxx_create_contacts.rb
```
class CreateContacts < ActiveRecord::Migration[5.2]
  def change

  end
end
```

ここに以下の内容を追記する。

* contactsというテーブルを作成
* nameというカラムを追加
* nameカラムに入れるのはstring型

@db/migrate/xxxx_create_contacts.rb
```
class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|  ## 追記
      t.string :name               ## 追記
    end                            ## 追記
  end
end
```

>マイグレーションファイルはテーブル名、カラム名、そこに入るデータ型を指定した設計図にあたる。Sinatra ActiveRecordの規約としてテーブル名は複数形にする。

>マイグレーションファイル名(create_contacts)はテーブル操作の内容が推測しやすいものにする。create_table_contactsとかの方がベターかも。




### 2.マイグレーションファイル(設計図)をもとにテーブルを作成する。

@terminal
```
$ bundle exec rake:db migrate
```

db/migrateディレクトリにschema.rbファイルが作成される。
>schema.rbは今後、rake db:migrateしたものが全部まとめて記述され、app.rbのデータベース全体の構造設計図となる。

@db/migrate/schema.rb
```
ActiveRecord::Schema.define(version: 2019_03_14_145544) do

  create_table "contacts", force: :cascade do |t|
    t.string "name"
  end

end
```
---

## app.rbにモデルを追記する

>'モデル'とは使用するテーブルの設定である。主にバリデーションを設定する。テーブル名と同じにすることで紐付けがされる。大文字で始まり単数形にする。Sinatra ActiveRecordの規約である。

@app.rb
```
class Contact < ActiveRecord::Base
  validates_presence_of :name
end
```

>この場合は、ActiveRecordから機能を継承したクラスContactを宣言している。中身としてはテーブルcontactsに関する設定となる。

---

## テーブルに値を保存する

>おさらい。データベース名: contacts、テーブル名: contacts、カラム: name

@app.rb
```
...
...

post '/contacts' do
  # postされたデータの取り出し
  name = params[:name]  ## <input name="name">
  puts name

  # DBへの保存
  contact = Contact.new({name: name})
  contact.save

  # リダイレクト
  redirect '/'
end
```

>Contact.new({name: name})でテーブル名contactのnameカラムにpostされてきた識別名nameの値を新規追加する、という意味。1つめのnameはテーブルのカラム名、2つめはinput name="name"のnameを指している。

---

## テーブルから値を取り出して表示する

index.erbに一覧を表示する想定。


コントローラーに変数を宣言
<br><br>
@app.rb
```
get '/' do
  @now = Time.now
  @contacts = Contact.all  ## 追記

  erb :index
end
```
<br><br>
ビューで変数を展開
<br><br>
@views/index.erb
```
<table>
    <tr>
      <th>ID</th>
      <th>name</th>
    </tr>
    <% @contacts.each do | contact | %>
    <tr>
      <td><%= contact.id %></td>
      <td><%= contact.name %></td>
    </tr>
    <% end %>
  </table>
```

><%=  %>は変数を展開して表示する。
><%  %>は処理はするが表示しない。

---

## 空白で送信されたらエラー表示を出す

コントローラーに条件分岐処置を追記

@app.rb<br>
変数contactを@contactとし、ビューから呼び出せるように変更。
```
post '/contacts' do
  # DBへの保存

  @contact = Contact.new({name: name})
  if @contact.save
    redirect '/' # topにリダイレクト
  else
    erb :contact_form # フォームを再度表示する
  end

end
```



エラーが出たときに遷移するビューにエラー表示を追記

@views/contact_new.rb
```
<% if @contact.errors.present? %>
  <p>エラーがあります</p>
  <ul>
    <% @contact.errors.full_messages.each do | message | %>
    <li><%= message %></li>
    <% end %>
  </ul>
  <% end %>
```

このまま実行するとcontact_new.erbでエラーが発生する。呼び出すべき変数@contactがないよ、と。

@app.rb
```
get '/contact_new' do
  @contact = Contact.new  ## 追記
  erb :contact_new
end
```
---

## セッションを使って1回だけメッセージを出す

>セッションとは複数の値をまとめて送受信できる変数のようなもの。今回はユーザーを新規作成したときに「○○さんを追加しました」というメッセージを１度だけ表示させる目的で利用する。

### アプリでセッションを有効化する

@app.rb
```
enable :sessions
```
ユーザーを新規作成したときにメッセージ内容を生成する。

@app.rb
```
post '/contacts' do

  # DBへの保存
  @contact = Contact.new({name: name})
  if @contact.save
    session[:message] = "#{name}さんを追加しました。"  ## 追記
    redirect '/'
  else
    erb :contact_new
  end

end
```

ユーザー一覧でセッションを受け取れるようにする。

@app.rb
```
get '/' do
  ...

  #@message = session[:message]
  @message = session.delete :message

  erb :index
end
```
>どちらも変数@messageでセッションを代入しているが、
session.delete :messageとすることで、変数に格納したらセッションを破棄できる。こうすることで1回だけ呼び出せる。



ビューでセッション内容を呼び出し、表示する。

@views/index.erb
```
<% if @message %>
  <p><%= @message %></p>
<% end %>
```

---

## irbコマンドを使ってターミナルからデータベースを操作する方法

>irb(interactive Ruby)とは、対話形式でRubyを実行するコマンド。

@terminal
app.rb上でirbを実行する。
```
$ irb -r ./app.rb
```
全件取ってくる
```
irb(main):001:0> Contact.all
```

id:4のレコードを取ってくる
```
> Contact.find(4)
```

最初、最後のレコードを取ってくる
```
> Contact.first

> Contact.last
```

新規レコードを追加する
```
> Contact.create(name: "テスト")
```

新規レコードを追加する(エラーが出たとき詳細を表示)
```
> Contact.create(name: "テスト")!
```

id:4のレコードを削除する
```
> c = Contact.find(4)
> c.destroy
```

レコードを全件削除する
```
> Contact.destroy_all
```

irbを終了する
```
> exit
```

Contact.***としている部分はapp.rbにモデルとして設定したクラス名の'Contact'を指している。テーブルcontactsについて操作をすることになる。

---

## テーブルにカラムを追加する

データベース構造を変更するには
1. マイグレーションファイルを生成する
2. マイグレーションファイルに変更する内容を記述する
3. マイグレーションを実行する
4. エラーが出たら...

### 1. マイグレーションファイルを生成する

@terminal
```
$ bundle exec rake db:create_migration NAME=add_email_to_contacts_table
```

### 2. マイグレーションファイルに変更する内容を記述する

@migrate/***add_email_to_contacts_table.rb
```
class AddEmailToContactsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :email, :string  ## 追記
  end
end
```

>add_column :テーブル名, :カラム名, :値の型

### 3. マイグレーションを実行する

@terminal
```
$ bundle exec rake db:migrate
```

これでdb/schema.rbの内容に反映されていたら成功！


### 4. エラーが出たら...

マイグレーションを1つ戻す方法

@terminal
```
$ bundle exec rake db:rollback
```

これを繰り返せば何もなかったところまで戻すこともできる。

---

## コントローラーを編集する

マイグレーションでデータベース構造は変更できたので、
コントローラーも追従させる。


今回はcontactsテーブルにemailカラムを追加したので、
emailをデータベースに追加できるようにする必要がある。

@app.rb
```
post '/contacts' do

  name = params[:name]
  email = params[:email]  ## 追記

  # DBへの保存
  @contact = Contact.new({name: name, email: email})  ## emailを追記

  if @contact.save
    session[:message] = "#{name}さんを追加しました。"
    redirect '/' # topにリダイレクト
  else
    erb :contact_new # フォームを再度表示する
  end

end
```

---

## ビューを編集する

さらにビューも追従させる。


今回はcontactsテーブルにemailカラムを追加したので、
1. フォームの入力画面にemail入力欄を追加する。
2. 一覧画面にemailの表示をする。

@views/contact_new.erb
```
<form action="/contacts" method="post">

      名前：<input type="text" name="name" value="<%= @contact.name %>">
      メール：<input type="text" name="email" value="<%= @contact.email %>">

    <input type="submit" value="送信">
  </form>
```

@views/index.erb
```
<table>
    <tr>
      <th>ID</th>
      <th>name</th>
      <th>email</th>
    </tr>
    <% @contacts.each do | contact | %>
    <tr>
      <td><%= contact.id %></td>
      <td><%= contact.name %></td>
      <td><%= contact.email %></td>
    </tr>
    <% end  %>
  </table>
```


