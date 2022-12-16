# docker-compose_phoenix
template

# インストールできているか確認
'''
docker compose run --rm app mix --version
docker compose run --rm db psql --version
'''
# 新しいプロジェクトを開始する場合
'''
docker compose run --rm app mix phx.new . --app myapp
'''

config/dev.exs
'''
config :mayapp, MyappWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
 '''
 
 config/dev.exs
 '''
 config :myapp, Myapp.Repo,
  username: "postgres", # 編集 (POSTGRES_USER)
  password: "postgres", # 編集 (POSTGRES_PASSWORD)
  hostname: "phx_docker_sample_db_1", # 編集 (コンテナ名)
  database: "myapp_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
 '''
 
 # dbを作成
 '''
  docker compose run --rm mix ecto.create
 '''
 
 # スタート
 '''
 docker compose up -d
 '''
 # コンテナ削除
 '''
  docker compose down
 '''
