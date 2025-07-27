variable "name" {
  description = "Назва інстансу або кластера"
  type        = string
}

variable "engine" {
  description = "Тип бази даних (наприклад, postgres, mysql)"
  type        = string
  default     = "postgres"
}
variable "engine_cluster" {
  description = "Тип кластера бази даних (наприклад, aurora-postgresql)"
  type        = string
  default     = "aurora-postgresql"
}
variable "aurora_replica_count" {
  description = "Кількість реплік для Aurora (для кластерів Aurora)"
  type        = number
  default     = 1
}

variable "aurora_instance_count" {
  description = "Кількість інстансів для Aurora (для кластерів Aurora)"
  type        = number
  default     = 2 # 1 primary + 1 replica
}
variable "engine_version" {
  description = "Версія бази даних (наприклад, 17.2 для PostgreSQL)"
  type        = string
  default     = "14.7"
}

variable "instance_class" {
  description = "Тип інстансу бази даних (наприклад, db.t3.medium)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Обсяг виділеного сховища в ГБ"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Назва бази даних"
  type        = string
}

variable "username" {
  description = "Ім'я користувача бази даних"
  type        = string
}

variable "password" {
  description = "Пароль користувача бази даних"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID VPC, в якому буде розгорнуто базу даних"
  type        = string
}

variable "subnet_private_ids" {
  description = "Список ID приватних підмереж для розгортання бази даних"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Список ID публічних підмереж для розгортання бази даних"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Чи буде база даних доступна з Інтернету"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Чи буде база даних розгорнута в кількох зонах доступності"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Налаштування параметрів бази даних"
  type        = map(string)
  default     = {}
}

variable "use_aurora" {
  description = "Чи використовувати Aurora"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Період зберігання резервних копій"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Теги для бази даних"
  type        = map(string)
  default     = {}
}

variable "parameter_group_family_aurora" {
  description = "Сімейство групи параметрів для Aurora"
  type        = string
  default     = "aurora-postgresql15"
}
variable "engine_version_cluster" {
  description = "Версія кластера бази даних"
  type        = string
  default     = "15.3"
}
variable "parameter_group_family_rds" {
  description = "Сімейство групи параметрів для RDS"
  type        = string
  default     = "postgres15"
}
