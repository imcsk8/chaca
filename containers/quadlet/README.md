# Elector Judicial Quadlet

## Installation

```bash
# useradd -m -U -c 'Elector Judicial App user' -s /bin/bash elector
# mkdir /etc/elector
# cp container.env /etc/elector/  
# cp electorjudicial.container /etc/containers/systemd/users/
# chown -R elector:elector
```

* Create user with database and set password

```bash
# sudo -i -u postgres createuser -d -W elector
# sudo -i -u postgres createdb -O elector elector
```

## Configuration

* Edit `/etc/elector/Rocket.toml`

```toml
[global.databases.postgres]
url = "postgres://elector:<password_given_in_createuser>@127.0.0.1:5432/elector"
```

There are more configuration directives to be tuned.

Run database migrations or load a dump of the database.

* Enable systemd unit

```bash
# systemctl daemon-reload
# systemctl enable  electorjudicial
```



## Usage

```bash
# systemctl start electorjudicial
```


