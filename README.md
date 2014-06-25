実践Docker
===
# 目的
Dockerでアプリ環境を構築するまでの手順を整理する

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| boot2docker　　 |1.0.0         |             |
| rbdock    　　  |0.2.0         |             |

[Docker入門](https://github.com/k2works/docker_introduction)

# 構成
+ [セットアップ](#1)
+ [アプリをつくる](#2)
+ [Dockerfileをつくる](#3)
+ [イメージを作る](#4)
+ [イメージを実行する](#5)
+ [テスト](#6)
+ [かたづけ](#7)
+ [Docker Hubにプッシュ](#8)
+ [おまけ](#9)

# 詳細
## <a name="1">セットアップ</a>
### VMとデータを共有できるようにする。
[ここ](https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c)からISOイメージをダウンロードする。
```bash
$ boot2docker stop
$ mv ~/.boot2docker/boot2docker.iso ~/.boot2docker/boot2docker.iso.backup
$ mv ~/Downloads/boot2docker-v1.0.1-virtualbox-guest-additions-v4.3.12.iso ~/.boot2docker/boot2docker.iso
$ VBoxManage sharedfolder add boot2docker-vm -name home -hostpath /Users
$ boot2docker up
```
[rbdock](http://deeeet.com/writing/2014/03/06/rbdock/)のインストール
```bash
$ gem install rbdock
```
## <a name="2">アプリをつくる</a>
```bash
$ hazel sample_sinatra
      create  sample_sinatra/config/initializers
      create  sample_sinatra/lib
      create  sample_sinatra/spec
      create  sample_sinatra/lib/.gitkeep
      create  sample_sinatra/public/stylesheets
      create  sample_sinatra/public/stylesheets/main.css
      create  sample_sinatra/public/javascripts
      create  sample_sinatra/public/javascripts/.gitkeep
      create  sample_sinatra/public/images
      create  sample_sinatra/public/images/.gitkeep
      create  sample_sinatra/public/images/hazel_icon.png
      create  sample_sinatra/public/images/hazel_small.png
      create  sample_sinatra/public/favicon.ico
      create  sample_sinatra/views
      create  sample_sinatra/views/layout.erb
      create  sample_sinatra/views/welcome.erb
      create  sample_sinatra/sample_sinatra.rb
      create  sample_sinatra/spec/sample_sinatra_spec.rb
      create  sample_sinatra/spec/spec_helper.rb
      create  sample_sinatra/config.ru
      create  sample_sinatra/Gemfile
      create  sample_sinatra/Rakefile
      create  sample_sinatra/README.md
$ cd sampel_sinatra
$ rackup config.ru
```

## <a name="3">Dockerfileをつくる</a>
```bash
$ cd sample_sinatra
$ rbdock 2.1.0 --rvm --app .
```
生成されたDockerfileがそのままでは動かないので修正する。
43行目を削除して44行目に以下を追加
```
RUN bash -l -c 'rvm use 2.1.0; bundle install'
```
## <a name="4">イメージを作る</a>
```bash
$ docker build -t="k2works/sample_sinatra" .
```
## <a name="5">イメージを実行する</a>
```bash
$ docker run -d -p 9292:9292 --name=test k2works/sample_sinatra 'rvm use ruby-2.1.0;rackup config.ru'
```
## <a name="6">テスト</a>
```bash
$ docker ps
CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                    NAMES
20f024e69a75        k2works/sample_sinatra:latest   bash -l -c 'rvm use    20 minutes ago      Up 4 seconds        0.0.0.0:9292->9292/tcp   test
$ curl -i $(boot2docker ip 2>/dev/null):9292
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
Content-Length: 1813
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Connection: keep-alive
Server: thin 1.6.2 codename Doc Brown

<!DOCTYPE html>
・・・
```
## <a name="7">かたづけ</a>
```bash
$ docker stop test
test
$ docker rm test
test
```
## <a name="8">Docker Hubにプッシュ</a>
### docker push
```bash
$ docker login
$ docker push k2works/sample_sinatra
```
### Docker Hubと連携
![](https://farm6.staticflickr.com/5273/14501239854_29422ce38c.jpg)  
Automated Buildを選択
![](https://farm4.staticflickr.com/3840/14315962849_eedbc730df.jpg)  
GitHubを選択
![](https://farm4.staticflickr.com/3918/14316118637_302dac4341.jpg)
![](https://farm6.staticflickr.com/5503/14315964898_88f9425f6c.jpg)  
Dockerfileが存在するレポジトリを選択
![](https://farm3.staticflickr.com/2923/14502571245_f4672b732d.jpg)  
Dockerfile Locationにはレポジトリ内のDocerfileの場所を指定（ここではsample_sinatra)
公開タイプを選択したらCreate Repositoryする。
![](https://farm4.staticflickr.com/3907/14501239744_e680fec5f4.jpg)
![](https://farm4.staticflickr.com/3891/14315917890_757f58e889.jpg)  
上記ではDockerfileのロケーションを間違えていたためビルドに失敗している。　　
![](https://farm4.staticflickr.com/3874/14501594752_1cda267c6b.jpg)
Docerfile Locationを_/sample_sinatra_に修正後Start a Buildを実行してビルドを正常終了させる。

## <a name="9">おまけ</a>
### 他のレポジトリからDcokerfileをつくる。
[sinatraにbootstrap実装](https://github.com/k2works/sinatra_bootstrap)のレポジトリを使う。
```bash
$ mkdir sample_gitrepo
$ cd sample_gitrepo/
$ rbdock 2.0.0-p247 --rvm --app https://github.com/k2works/sinatra_bootstrap
$ docker build -t='k2works/sampel_gitrepo' .
$ docker run -d -p 9292:9292 --name=test_sample_gitrepo k2works/sample_gitrepo 'rvm use 2.0.0-p247;rackup config.ru'
```
### Ruby on RailsプロジェクトのDockerfileをつくる。
```bash
$ rails new sample_rails_app
$ cd sample_rails_app
$ rdbock 2.1.0 --rvm --app .
$ docker build -t='k2works/sample_rails_app' .
$ docker run -d -p 3000:3000 --name=test_rails k2works/sample_rails_app 'rvm use ruby-2.1.0;rails server'
```
注意：Dockerfileは編集する必要あり。

# 参照
+ [Dockerizing a Node.js web application](http://docs.docker.com/examples/nodejs_web_app/#test)
+ [boot2docker Vagrant Box](https://github.com/mitchellh/boot2docker-vagrant-box)
+ [boot2docker together with VirtualBox Guest Additions](https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c)
+ [rbdockというRuby/Rails/Sinatra用のDockerfileを生成するgemをつくった](http://deeeet.com/writing/2014/03/06/rbdock/)
+ [Vagrant + DockerでSinatraを動かす](http://deeeet.com/writing/2013/12/27/sinatra-on-docker/)
+ [Dockerfile for installing Ruby 2.0 and RVM](https://gist.github.com/konklone/6662393)
