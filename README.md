実践Docker
===
# 目的
Dockerでアプリ環境を構築するまでの手順を整理する

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| boot2docker　　 |1.0.0         |             |
| vagrant   　　  |1.6.0         |             |

[Docker入門](https://github.com/k2works/docker_introduction)

# 構成
+ [セットアップ](#1)
+ [アプリをつくる](#2)
+ [Dockerfileをつくる](#3)
+ [イメージを作る](#4)
+ [イメージを実行する](#5)
+ [テスト](#6)

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
## <a name="2">アプリをつくる</a>
## <a name="3">Dockerfileをつくる</a>
## <a name="4">イメージを作る</a>
## <a name="5">イメージを実行する</a>
## <a name="6">テスト</a>

# 参照
+ [Dockerizing a Node.js web application](http://docs.docker.com/examples/nodejs_web_app/#test)
+ [boot2docker Vagrant Box](https://github.com/mitchellh/boot2docker-vagrant-box)
+ [boot2docker together with VirtualBox Guest Additions](https://medium.com/boot2docker-lightweight-linux-for-docker/boot2docker-together-with-virtualbox-guest-additions-da1e3ab2465c)
