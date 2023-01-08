# Run MySQL and Vault

> Docker

## Docker Network
```
docker network create docker-net
```

## MYSQL via docker
```bash
docker run \
    --name mysql-for-vault \
    --network docker-net \
    --env MYSQL_ROOT_USERNAME=root \
    --env MYSQL_ROOT_PASSWORD=password \
    --publish 3306:3306 \
    mysql:latest
```

## Run Vault Option 1 - via binary
```bash
vault server -dev -dev-root-token-id=root -log-level=trace
```

## Run Vault Option 2 - via docker
```bash
docker run \
    --name vault-dev \
    --network docker-net \
    --env VAULT_DEV_ROOT_TOKEN_ID=root \
    --env VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200 \
    --publish 8200:8200 \
    vault:latest
```