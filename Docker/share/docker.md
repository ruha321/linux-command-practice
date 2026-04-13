# Docker学習メモ

## Dockerfile

ベースイメージの指定
`FROM ubuntu:latest`

コンテナイメージ作成時に実行させるコマンド

```Dockerfile
RUN apt update \
    && apt install curl -y
```

RUNで実行されるシェルの指定
`SHELL ["/bin/bash", "-l", "-c"]`

コンテナ内にファイル・ディレクトリをコピー
`COPY ["index.html", "/usr/share/nginx/index.html"]`

コンテナ内にtarファイルを自動展開したものやURL先のリモートファイルなどを追加（コピー）
`ADD ["dist.tar", "/usr/share/nginx/dist"]`

環境変数の設定
`ENV NAME=ruha321`

公開ポートを設定
`EXPOSE 8080`

指定が無いときにデフォルトで実行されるコマンド
`CMD ["/bin/bash"]`

docker run実行時に行われるコマンド
`ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]`

RUN, CMD, ENTRYPOINGを実行するユーザーを指定
`USER user`

共有可能ボリュームをマウント
`VOLUME ["/var/lib/mysql"]`

コピー系やコマンド系の作業ディレクトリを指定
`WORKDIR /home/ubuntu`

...

## イメージとビルド

イメージビルドコマンド
`docker image build -t image-name:tag dir -f Dockerfile-2`

イメージの確認
`docker image ls`

イメージビルドの履歴確認
`docker image history image-name:tag`

イメージの削除
`docker image rm image-name:tag`

## マルチステージビルド

```Dockerfile
# ステージ１ ビルドステージ
FROM golang:1.16.4-alpine3.13 AS builder

COPY ./main.go ./

RUN go build -o /msb ./main.go

# ステージ２
FROM alpine:3.13

COPY --from=builder /msb /usr/local/bin/msb

ENTRYPOINT ["/usr/local/bin/msb"]
```

## imageのpushとpull

Trivyのような脆弱性検査ツールを使用する

```bash
trivy image ruha321/docker-test:0.01
trivy nginx:1.19.2
```

push/pull

```bash
# push
docker login
docker image push ruha321/docker-test:0.01
# pull
docker image pull ruha321/docker-test:0.01
```

## コンテナの起動

例
`docker container run -d --name container -p 8080:80 --rm -v /home/user/share:/usr/share image-name:tag`

| オプションの名前 | オプションの指定方法 | composeとの対応 ｜
| -------------------- | -------------- | ----------------|
| フォアグラウンドかバックグラウンドか | -it か -d | --- |
| コンテナの名前 | --name container-name | |
| host:containerのポートの対応 | -p 8080:80 | |
| コンテナの自動削除 | --rm | |
| ボリュームのマウント | -v /path/host:/path/container | volume: |

コンテナ内での操作：例
`docker container exec -it container-name /bin/bash`

コンテナに関わるコマンド

```bash
docker container ls
docker container ls -a
docker container stop container-name`
docker container start container-name`
docker container cp copy.html container-name:/usr/share/nginx/html
docker container cp conttainer-name1:/workspace/dir_name/copy.html container-name2:/usr/share/nginx/html
docker container stats container-name # 使用状況確認
docker container inspect container-name # 情報確認
docker container rm container-name
docker container logs container-name # ログの確認 Dockerfile等で設定する必要がある -fでリアルタイム化
```

## 永続化データ

1. バインドマウント (Bind mount)
2. ボリューム (Volume)
3. 一時ファイルシステムのマウント (tmpfs mount)

バインドマウント

ホスト側パスはpodmanが動いているマシンのパス

```bash
podman container run -d --name docker-test --rm -p 8080:80 -v /home/ruha321/github-and-linux-practice/Docker:/usr/share/nginx/html nginx
```

ボリューム

```bash
podman volume create htdocs
podman volume ls
podman run -d --name volume-nginx -p 8080:80 -v htdocs:/usr/share/nginx/html nginx
podman volume inspect htdocs # ボリュームのマウント先が分かる
```

一時ファイルシステムのマウント

```bash
podman container run -d --name tmpfs-nginx --mount type=tmpfs,destination=/root/tmp,tmpfs-size=10,tmpfs-mode=755 nginx
```

データボリュームコンテナ

```bash
podman container run -it -d --name data-volume -v /tmp/data-volume/share:/tmp/data busybox
podman container run -it -d --name share01 --volumes-from data-volume ubuntu
podman container run -it -d --name share02 --volumes-from data-volume ubuntu
```

## コンテナのネットワーク

1. none
2. host
3. bridge

```bash
podman network ls
podman network inspect podman
```

ブリッジネットワークとアプリケーション

```bash
podman network create wordpress-network
podman network ls
podman container run -d --name mysql --network wordpress-network \
-e MYSQL_ROOT_PASSWORD=wordpress \
-e MYSQL_DATABASE=wordpress \
-e MYSQL_USER=wordpress \
-e MYSQL_PASSWORD=wordpress \
mysql:8.0.25
podman container run -d --name wordpress --network wordpress-network \
-p 8080:80 \
-e WORDPRESS_DB_HOST=mysql:3306 \
-e WORDPRESS_DB_NAME=wordpress \
-e WORDPRESS_DB_USER=wordpress \
-e WORDPRESS_DB_PASSWORD=wordpress \
docker.io/library/wordpress:php7.4-apache
```
