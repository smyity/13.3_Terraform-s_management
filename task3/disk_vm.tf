### ---ДИСКИ--- ###
resource "yandex_compute_disk" "virt_disk" {
  count    = 3
  name     = "disk-${count.index}"
  size     = 1
  type     = "network-ssd"
  zone     = var.default_zone
}

### –--ВМ–-- ###
resource "yandex_compute_instance" "vm" {
  name        = "storage"
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

  # добавление дисков
  dynamic secondary_disk {
    for_each = yandex_compute_disk.virt_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vms_metadata

}
