# docker-compose_phoenix
template

# インストールできているか確認
```
docker compose run --rm app mix --version
```
# 新しいプロジェクトを開始する場合
```
docker compose run --rm app mix phx.new . --app myapp
```
 
 # dbを作成
 ```
  docker compose run --rm mix ecto.create
 ```
 
 # スタート
 ```
 docker compose up -d
 ```
 # コンテナ削除
 ```
  docker compose down
 ```
