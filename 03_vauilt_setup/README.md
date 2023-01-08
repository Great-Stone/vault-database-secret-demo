# Vault Database Secret Setup

## Set Env
```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
```

### Enable Secrets Engine
```bash
vault secrets enable database
```

### Database Config - Root Credential
> Option 1 - local vault >> DB ADDR = 127.0.0.1 
> Option 2 - docker vault >> DB ADDR = vault-dbsecret-mysql

```bash
vault write database/config/mysql-database \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(vault-dbsecret-mysql:3306)/" \
    allowed_roles="*" \
    username="vault" \
    password="password"
```

### Root Credential Rotate
```bash
vault write -force database/rotate-root/my-mysql
```

### Root Credential Rotate Check
```bash
mysql -h 127.0.0.1 -P 3306 -u vault --password=password
```

## Dynamic Setup

```bash
vault write database/roles/mysql-dynamic \
    db_name=mysql-database \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" \
    default_ttl="1m" \
    max_ttl="2m"
```

## Dynamic Check

```bash
vault read database/creds/mysql-dynamic
```

## Check dynamic secret password
```bash
mysql -h 127.0.0.1 -P 3306 -u <NEW USERNAME> --password=<NEW PASSWORD>
# mysql -h 127.0.0.1 -P 3306 -u v-token-mysql-dyna-tQ5gjAssx2ROP --password=QHWC47LDDe-hC0qS3N2a
```

```sql
Select user from mysql.user;

+----------------------------------+
| user                             |
+----------------------------------+
| root                             |
| static                           |
| v-token-mysql-dyna-tQ5gjAssx2ROP |
| vault                            |
| mysql.infoschema                 |
| mysql.session                    |
| mysql.sys                        |
| root                             |
+----------------------------------+
8 rows in set (0.01 sec)
```

## Static Before
```bash
mysql -h 127.0.0.1 -P 3306 -u static --password=password
```

## Static Setup
```bash
vault write database/static-roles/mysql-static \
    db_name=mysql-database \
    rotation_statements="ALTER USER \"{{name}}\" IDENTIFIED BY \"{{password}}\";" \
    username="static" \
    rotation_period="1h"
```

## Static Check
```bash
vault read database/static-creds/mysql-static
```

## Check staic secret password
```bash
mysql -h 127.0.0.1 -P 3306 -u static --password=<NEW PASSWORD>
# mysql -h 127.0.0.1 -P 3306 -u static --password=b-gBj51oBAGC3LiSHn3A
```

## Rotate staic secret password
```bash
vault write -force database/rotate-role/mysql-static
```