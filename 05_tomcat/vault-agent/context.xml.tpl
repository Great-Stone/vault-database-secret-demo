<?xml version="1.0" encoding="UTF-8"?>
<Context>
    {{  with secret "database/static-creds/mysql-static" }}
    <Resource name="jdbc/mysql"
        auth="Container"
        type="javax.sql.DataSource"
        maxTotal="10"
        maxIdle="20"
        maxWaitMillis="10000"
        username="{{ .Data.username }}"
        password="{{ .Data.password }}"
        driverClassName="com.mysql.cj.jdbc.Driver"
        validationQuery="SELECT 1"
        url="jdbc:mysql://127.0.0.1:3306/mysql"/>
    {{  end  }}
</Context>
