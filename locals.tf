locals {
  bucket_name = var.text1 # -${var.text2}"
}

locals {
  ingress_rules = [{
    port        = 22
    description = "ingress rule for port 22"
    },
    {
      port        = 443
      description = "ingress rule for port 443"
    },
    {
      port        = 3306
      description = "ingress rule for my_sql"
    },
    {
      port        = 80
      description = "port enable for nginx"
    },
    {
      port        = 8080
      description = "ingress rule for port 8080 using jenkins"
  }]
}
