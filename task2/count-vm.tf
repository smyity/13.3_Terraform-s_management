variable "count_vm_name" {
  type    = list(string)
  default = ["wm-1", "wm-2"]
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
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = false # использование внешнего ip
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vms_metadata
  
  # Создание данных ВМ только после создания ВМ из for_each-vm.tf
  depends_on = [yandex_compute_instance.second]
}
