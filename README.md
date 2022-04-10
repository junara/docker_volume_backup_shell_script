# Backup docker volume

Back up docker volume sample shell script.

## SAMPLE USAGE

Create sample MySQL docker container with volume mount.

```shell
docker compose up -d
```

Check status is running.

```shell
docker compose ps
NAME                                     COMMAND                  SERVICE             STATUS              PORTS
docker_volume_backup_shell_script-db-1   "/entrypoint.sh mysq…"   db                  running (healthy)   33060-33061/tcp

```

```shell

docker compose exec db mysql -uroot -ppassword 
```

Add database.

```mysql
create database hoge;

show databases;
+--------------------+
| Database           |
+--------------------+
| hoge               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

exit

```

Check "hoge" database is added.

Down mysql container

```shell
docker compose down
```

Check back up target volume name.

```shell
docker volume ls

local     docker_volume_backup_shell_script_db_data

```

Target volume is "docker_volume_backup_shell_script_db_data".

Create target volume backup.

Target volume is copied to backup docker image. Example backup volume name is "bck_volume".

```shell
sh create_snapshot.sh -t docker_volume_backup_shell_script_db_data -b bck_volume
```

```shell
docker volume ls

local     docker_volume_backup_shell_script_db_data
local     bck_volume
```

Alter mysql database.

```shell
docker compose up -d
docker compose exec db mysql -uroot -ppassword 
```

Delete database.

```mysql
drop database hoge;

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

exit
```

Restore from backup volume (Example `bck_volume`).

```shell
docker compose down
sh restore_snapshot.sh -t docker_volume_backup_shell_script_db_data -b bck_volume
```

Confirm backup.

```shell
docker compose up -d
docker compose exec db mysql -uroot -ppassword 
```

```mysql
show databases;
+--------------------+
| Database           |
+--------------------+
| hoge               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

exit
```
