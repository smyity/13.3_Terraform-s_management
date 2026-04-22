resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl",

  { webservers = yandex_compute_instance.first[*]
    databases  = values(yandex_compute_instance.second)
    storage    = [yandex_compute_instance.vm]
    use_ext_ip = var.ext_ip
  })

  filename = "${path.module}/inventory.ini"
}

/*
path.module - встроенная переменная Terraform, которая возвращает абсолютный путь к папке, в которой находится текущий .tf файл
[*] - используется для ВМ созданных с помощью count
values() - используется для ВМ созданных с помощью each_for
[полностью список] - используется для просто созданных ВМ
use_ext_ip - проверка, используется ли внешний ip
*/