# DB Setup

## DB Login
```bash
mysql -h 127.0.0.1 -P 3306 -u root --password=password
```

## Create user
```sql
CREATE USER 'vault'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'vault'@'%' WITH GRANT OPTION;
GRANT CREATE USER ON *.* to 'vault'@'%';

CREATE USER 'static'@'%' IDENTIFIED BY  'password';
GRANT SELECT ON *.* TO 'static'@'%';

Select user from mysql.user;
```

## Check user - vault
```bash
mysql -h 127.0.0.1 -P 3306 -u vault --password=password
```