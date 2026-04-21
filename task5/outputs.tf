output "task5" {
  value = [
    for vm in concat(yandex_compute_instance.first[*], values(yandex_compute_instance.second)) : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }
  ]
  description = "Список данных по созданным ВМ"
}
