# Vault Agent로 파일 자동 교체

## 1. Vault Agent를 위한 인증 수단 활성화 - AppRole

### 1.1 AppRole 활성화
```bash
vault auth enable approle
```

### 1.2 AppRole 인증에 부여할 접근 정책 설정
```bash
vault policy write database -<<EOF
path "database/static-creds/*" {
  capabilities = [ "read" ]
}
EOF
```

### 1.3 AppRole에 생성한 정책 맵핑
```bash
vault write auth/approle/role/database policies="database"
```

### 1.4 Vault Agent를 위한 RoleID 생성
```bash
cd vault-agent
vault read -field=role_id auth/approle/role/database/role-id > roleid
```

### 1.5 Vault Agent를 위한 SecretID 생성
```bash
cd vault-agent
vault write -force -field=secret_id auth/approle/role/database/secret-id > secretid
```

## 2. Tomcat 테스트

### 2.1 빠른 테스트를 위해 교체 주기 변경

```bash
vault write database/static-roles/mysql-static \
    db_name=mysql-database \
    rotation_statements="ALTER USER \"{{name}}\" IDENTIFIED BY \"{{password}}\";" \
    username="static" \
    rotation_period="1m"
```

### 2.2 Vault Agent 실행

```bash
vault agent -config=config.hcl
```

### 2.3 Tomcat 실행 후 웹 페이지의 메시지 확인
```bash
$TOMCAT_HOME/bin/startup.sh
```

테스트 페이지 : <http://127.0.0.1:8080/test>