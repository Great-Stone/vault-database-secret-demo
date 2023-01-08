pid_file = "./pidfile"

vault {
  address = "http://127.0.0.1:8200"
  retry {
    num_retries = 3
  }
}

auto_auth {
  method {
    type = "approle"
    config = {
      role_id_file_path = "roleid"
      secret_id_file_path = "secretid"
      remove_secret_id_file_after_reading = false
    }
  }
}

template {
  source = "context.xml.tpl"
  destination = "../apache-tomcat-10.0.27/webapps/test/META-INF/context.xml"
}