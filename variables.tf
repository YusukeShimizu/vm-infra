variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPリージョン"
  type        = string
}

variable "zone" {
  description = "GCPゾーン"
  type        = string
}

variable "instance_name" {
  description = "VMインスタンス名"
  type        = string
}

variable "machine_type" {
  description = "VMマシンタイプ"
  type        = string
}

variable "boot_disk_size" {
  description = "ブートディスクサイズ（GB）"
  type        = number
}

variable "my_ip_cidr" {
  description = "SSH接続を許可するIPアドレス（CIDR形式）"
  type        = string
} 