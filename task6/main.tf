# Создание облачной сети
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Создание подсети
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# используемый образ
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

### –--Список ВМ–-- ###
variable "count_vm_name" {
  type    = list(string)
  default = ["wm-1"]
}

### –--ВМ–-- ###
resource "yandex_compute_instance" "first" {
  count       = length(var.count_vm_name)
  name        = var.count_vm_name[count.index]
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.ext_ip
  }

  metadata = local.vms_metadata
}

## ---Создание файла inventory--- ##
resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl",

  { cloud_vm = yandex_compute_instance.first[*]
    use_ext_ip = var.ext_ip
    vm_user   = var.vm_user
  })

  filename = "${path.module}/inventory.ini"
}

## ---Запуск ansible playbook--- ##
resource "null_resource" "ansible" {
  # запуск ansible после того, как будет готов файл inventory.ini
  depends_on = [local_file.inventory]
  provisioner "local-exec" {
    command = "sleep 60 && ansible-playbook -i inventory.ini install_docker.yml"
  }
}