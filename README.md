# 作業用のディレクトリを作成する

@console
```
$ mkdir sinatra
$ cd sinatra
$ touch app.rb
```

## コンソールに文字列を出力してみる

@console
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

@console

```
$ ruby app.rb

[2019-03-11 23:29:28] INFO  WEBrick 1.4.2
[2019-03-11 23:29:28] INFO  ruby 2.5.0 (2017-12-25) [i686-linux]
== Sinatra (v2.0.5) has taken the stage on 4567 for development with backup from WEBrick
[2019-03-11 23:29:28] INFO  WEBrick::HTTPServer#start: pid=15682 port=4567
```

## htmlのテンプレートを用意する

「views」というディレクトリを作成する（重要！）
sinatraではテンプレートファイルの場所は「views」にするという規約がある。

@console
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

* 変数nowに@をつけるとviwes/index.erbから参照できる変数となる
* erb :indexとすることで/にアクセスされたらindex.erbが表示される（呼び出される）ようになる。
* テンプレート（views/***.erb）からapp.rbで定義した変数を呼び出す場合は
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

* sinatraでは静的ファイルの場所は「public」にするという規約がある。
* 「public」にはcssの他、通常のhtmlファイルで変数を使わないページをおくこともできる。

@console
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

## フォームを使う

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

sinatraではテンプレートを作ったら、そのerbファイルをどのようなurlがリクエストがきたときに表示してやるのかをapp.rbに書いてやる必要がある。
app.rbはコントローラーの役割がある。

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

get '/contact_new' do
  erb :contact_form
end
```

# gemをbundlerを使って管理する

ここまではgemが必要なときに都度、gem install ○○とコマンドを打ってインストールしたが、必要なgemが増えると管理が難しくなる。
そこで、gemを管理するためのgem「bundler」を使って管理する。

## インストール

@console

```
$ gem install bundler
```

インストールできたら次は管理につかうGemfileを作成する。

## Gemfileを作成

@console

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
Bundler.require   ## 書く


get '/' do
  @now = Time.now
...
```

これでgemの管理をGemfileを通してできる環境が整った。

## あらためてGemfileからgemをインストールする

@console
```
$ bundle install --path vendor/bundle
```

オプション --path vendor/bundle

インストールしたgemをvendorというディレクトリで管理するよ、ということ。

## アプリを起動してみる

bundleを使ってgemをインストールすると起動コマンドが変わる。(先頭にbundle execをつける)

@console
```
$ bundle exec ruby app.rb
```

