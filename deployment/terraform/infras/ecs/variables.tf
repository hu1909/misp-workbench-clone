variable "enable_ecs" {
  description = "Deploy application with ECS"
  type = bool
  default = true
}

variable "service_name" {
  description = "Name of a service"
  type = string 
}

variable "cluster_name" {
  description = "Name of a cluster ECS"
  type = string
}

variable "task_definition" {
  description = "Task Definition Reference"
  type = string
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port of a container"
  type = number
}

variable "security_groups" {
  type = list(string)
  description = "List of security groups for a service"
}

variable "load_balancer_target_group" {
  description = "ARN of the load balancer target group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks"
  type        = number
  default     = 300
}