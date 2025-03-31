output "dev_vm_public_ip" {
  description = "開発VM用インスタンスのパブリックIPアドレス"
  value       = google_compute_instance.dev_vm.network_interface[0].access_config[0].nat_ip
} 