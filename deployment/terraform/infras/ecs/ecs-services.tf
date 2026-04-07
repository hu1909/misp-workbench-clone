resource "aws_ecs_service" "service-template" {
  count = var.enable_ecs ? 1 : 0
  name  = var.service_name

  cluster                            = var.cluster_name
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = var.load_balancer_target_group != "" ? var.health_check_grace_period_seconds : null

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.misp-workbench-dns-service.arn
    container_name = var.container_name
    container_port = var.container_port
  }

  network_configuration {
    subnets          = module.vpc-misp.private_subnets
    assign_public_ip = false
    security_groups  = var.security_groups
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer_target_group != "" ? [1] : []
    content {
      target_group_arn = var.load_balancer_target_group
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  depends_on = [aws_service_discovery_service.misp-workbench-dns-service]

  tags = var.tags
}