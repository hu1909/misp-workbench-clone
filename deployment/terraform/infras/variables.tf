variable "enable_ecs" {
  default     = 1
  description = "Deploy application with ECS"
}

variable "frontend_target_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the target group for frontend ALB. Leave empty to skip load balancer attachment."
}

variable "api_target_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the target group for API ALB. Leave empty to skip load balancer attachment."
}

variable "flower_target_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the target group for Flower monitoring UI. Leave empty to skip load balancer attachment."
}

variable "dashboards_target_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the target group for OpenSearch Dashboards. Leave empty to skip load balancer attachment."
}