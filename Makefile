# Posadev

.env:
	echo "DATABASE_URL=postgres://postgres:prueba123@127.0.0.1:9432/postgres" > .env

./www/static:
	mkdir -p www/static

./data:
	mkdir data

dirs: www/static data .env

db: data
	podman run -d --replace --name=chaca_pg                      \
		-e POSTGRES_PASSWORD=prueba123                           \
		-v ./data:/var/lib/postgresql/data:U,Z                   \
		-p 127.0.0.1:9432:5432 ghcr.io/enterprisedb/postgresql:16

clean_db:
	utils/drop_db.sh

bootstrap: db
	utils/init_db.sh

run: dirs db
	cargo run

debug: dirs db
	ROCKET_LOG_LEVEL=debug cargo run

clean:
	cargo clean
