# ベースイメージの選択
FROM ubuntu:latest

# イメージ作成用コマンドを実行
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get full-upgrade -y \
    && apt-get autoremove -y \
    && apt-get install -y nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# ホストのファイルをコンテナイメージ内にコピー
COPY ./share/docker.html /var/www/html

# コンテナ起動時に実行するコマンド
ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]