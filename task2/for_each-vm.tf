variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number, core_fraction=number, scheduling=bool, external_ip=bool }))
  default = [
    {
        vm_name       = "main"
        cpu           = 2
        ram           = 4
        disk_volume   = 20
        core_fraction = 20
        scheduling    = true
        external_ip   = false
    },
    {
        vm_name       = "replica"
        cpu           = 2
        ram           = 2
        disk_volume   = 15
        core_fraction = 20
        scheduling    = true
        external_ip   = false
    }
  ]
}

### –--ВМ–-- ###
resource "yandex_compute_instance" "second" {
  # преобразование list в map
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = each.value.scheduling
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = each.value.external_ip # использование внешнего ip
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vms_metadata
}
