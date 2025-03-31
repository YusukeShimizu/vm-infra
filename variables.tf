variable "project_id" {
  type        = string
  description = "GCPプロジェクトID"
}

variable "region" {
  type        = string
  description = "リソースをデプロイするリージョン"
  default     = "asia-northeast1"
}

variable "zone" {
  type        = string
  description = "リソースをデプロイするゾーン"
  default     = "asia-northeast1-a"
}

variable "my_ip_cidr" {
  type        = string
  description = "SSHアクセスを許可するIPアドレス（CIDR形式）"
} 