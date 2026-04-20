locals {
  description = "блок metadata для ВМ"
  vms_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}
