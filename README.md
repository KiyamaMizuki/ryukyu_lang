# ryukyu_lang

ryukyu_langは言語解析のwebアプリです

# 動作
※ローカルホストで建てた際(potrは任意.以下の実行方法で説明します。)  
①http://localhost:8080/form.html  にアクセスしたら言語解析用のファイルを選択し、アップロードしてください  
その後、②http://localhost:8080/web/upload2.php  に自動で飛ばされます。その際にアップロードしたファイルと解析結果のzipファイルがダウンロードできます。 
現在、①から②を実行する際にb時間以上経過するとtimeoutするようにしています。


# 要件
Docker   
Client Version:           20.10.0
Server Version:           20.10.0
# インストール
dockerのインストール
公式ページからインストールしてください  
https://www.docker.com/

## docker container内でインストールしたパッケージ
BaseはUbunutu 20.04を使用しています。

・locales ja_JP.UTF-8
→言語設定を日本語(ja_JP.UTF-8)にする。これでhtmlファイルで日本語が文字化けしない。

・sudo
→管理者権限での実行が可能

・R
→言語解析の処理がRで書かれている為

　・Rのパッケージ　
   readr
   phangorn
   doMC
   MASS

・nginx
→web serverはnginxを使用しています

・vim
→コンテナ内で作業出来る様にテキストエディタvimを使用

・php-fpm
→htmlからRにファイルを受け渡すさ際の処理をphpで実装している為必要

# 実行方法
ターミナルでこのプロジェクトをダウンロードしたディレクトリに移動して
```
docker build ./ -t "任意のimage名"
```
を実行してください。

```
$docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
test         latest    6bad338663cb   3 days ago    1.13GB
ubuntu       20.04     4dd97cefde62   3 weeks ago   72.9MB
```
docker imagesコマンドを実行して上記のように表示されていれば成功です。

次にimagesからコンテナを作成します。
```
docker run --name "任意のコンテナ名" -d -p 8080:80 "さっき作成したimage名"
```
上記では-pコマンドでdockerの80番ポートとlocalの8080番ポートを紐付けていますが8080番の方は各自で変更可能です。既に使用されていた場合は別のポート番号を指定してください。

```
$docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED      STATUS      PORTS                  NAMES
d7417131d9d3   test      "/start.sh"   3 days ago   Up 3 days   0.0.0.0:8080->80/tcp   ryukyu-lang
```
docker psコマンドで上記のようにSTATUSがUPなら成功です。

また、コンテナに入ってプロジェクトを編集したい場合は
```
docker exec -i -t "コンテナ名" bash
```
でコンテナに入れます。

# 各ファイルの説明
```
ryukyu_lang/
 ├ R/
 │ ├ execution/
 │ │  ├ execution_msa.R
 │ │  └ execution_psa.R
 │ │
 │ └ lib/
 │ │  └ 割愛
 │ │
 │ ├ README.txt
 │ ├ install_command.R　☆
 │ ├ parallel_config.R
 │ └ ryukyu.sh
 │
 ├ Dockerfile          ☆
 ├ default             ☆
 ├ form.html           ☆
 ├ input.csv           ☆
 ├ php.ini             ☆
 ├ start.sh            ☆
 └ upload2.php         ☆
 ```
 ryukyu_lang/R配下は宮城さんの書いてくれた言語解析の為のパッケージです。
 ☆マークがついてる部分がデフォの設定を変更する為のファイルになります。  
 
 ## install_command.R
 Rで使用するパッケージをここでダウンロードしています。
 
 ## Dockerfile
 Dockerのイメージを自動で作成してくれるファイルです。修正箇所がある際にはこのファイルから編集してください。
 
 ## default
 nginxの設定ファイルです。ここでnginxの　timeoutの設定やドキュメントルートの設定を書いています。
 コンテナ内の/etc/nginx/sites-enabled/defaultにマウントしています。
 
 ## form.html
 inputファイルをアップロードするページです。
 
 ## input.csv 
 test用のinputファイルです。  
 
 ## php.ini  
 php-fpmの設定ファイルです。ここでphpに対する  
 1.アップロードできるファイルのサイズの最大値  
 2.POSTすることのできるデータの最大値  
 3.スクリプトが確保できるメモリの最大値
 4.phpの処理の実行時間  
 を設定しています。
 またそれぞれ1024M,1024M,1024M,0に設定しています。
 コンテナ内の/etc/php/7.4/fpm/php.iniにマウントしています。
 
 ## start.sh 
 nginxとphp-fpmを起動する処理が書かれています。
 
 ## upload2.php 
htmlで受け取ったinputファイルをRに渡し結果をブラウザに表示する処理を書いています
