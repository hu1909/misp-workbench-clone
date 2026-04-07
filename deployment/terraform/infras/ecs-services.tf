resource "aws_ecs_cluster" "misp-workbench" {
  count = var.enable_ecs ? 1 : 0
  name  = "misp-workbench-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "misp-workbench-cluster"
    Environment = "production"
  }
}

# API Service
module "ecs-api" {
  source = "./ecs"

  enable_ecs                   = var.enable_ecs
  service_name                 = "api"
  cluster_name                 = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition              = "api:latest" # TODO: Replace with actual task definition ARN
  desired_count                = 2
  container_name               = "api"
  container_port               = 80
  security_groups              = [aws_security_group.api-sg.id]
  load_balancer_target_group   = var.api_target_group_arn
  health_check_grace_period_seconds = 60

  tags = {
    Name        = "api-service"
    Environment = "production"
    Component   = "backend"
  }
}

# Worker Service (Celery)
module "ecs-worker" {
  source = "./ecs"

  enable_ecs                        = var.enable_ecs
  service_name                      = "worker"
  cluster_name                      = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition                   = "worker:latest" # TODO: Replace with actual task definition ARN
  desired_count                     = 2
  container_name                    = "worker"
  container_port                    = 8080 # Dummy port for service registry
  security_groups                   = [aws_security_group.worker-sg.id]
  load_balancer_target_group        = "" # No load balancer
  health_check_grace_period_seconds = 0  # No load balancer

  tags = {
    Name        = "worker-service"
    Environment = "production"
    Component   = "backend"
  }
}

# Beat Service (Celery Scheduler)
module "ecs-beat" {
  source = "./ecs"

  enable_ecs                        = var.enable_ecs
  service_name                      = "beat"
  cluster_name                      = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition                   = "beat:latest" # TODO: Replace with actual task definition ARN
  desired_count                     = 1              # Only one beat scheduler needed
  container_name                    = "beat"
  container_port                    = 8080 # Dummy port for service registry
  security_groups                   = [aws_security_group.beat-sg.id]
  load_balancer_target_group        = "" # No load balancer
  health_check_grace_period_seconds = 0  # No load balancer

  tags = {
    Name        = "beat-service"
    Environment = "production"
    Component   = "backend"
  }
}

# Flower Service (Celery Monitoring)
module "ecs-flower" {
  source = "./ecs"

  enable_ecs                   = var.enable_ecs
  service_name                 = "flower"
  cluster_name                 = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition              = "flower:latest" # TODO: Replace with actual task definition ARN
  desired_count                = 1
  container_name               = "flower"
  container_port               = 5555
  security_groups              = [aws_security_group.flower-sg.id]
  load_balancer_target_group   = var.flower_target_group_arn
  health_check_grace_period_seconds = 30

  tags = {
    Name        = "flower-service"
    Environment = "production"
    Component   = "monitoring"
  }
}

# Frontend Service
module "ecs-frontend" {
  source = "./ecs"

  enable_ecs                   = var.enable_ecs
  service_name                 = "frontend"
  cluster_name                 = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition              = "frontend:latest" # TODO: Replace with actual task definition ARN
  desired_count                = 2
  container_name               = "frontend"
  container_port               = 80
  security_groups              = [aws_security_group.frontend-sg.id]
  load_balancer_target_group   = var.frontend_target_group_arn
  health_check_grace_period_seconds = 30

  tags = {
    Name        = "frontend-service"
    Environment = "production"
    Component   = "frontend"
  }
}

# OpenSearch Service
module "ecs-opensearch" {
  source = "./ecs"

  enable_ecs                        = var.enable_ecs
  service_name                      = "opensearch"
  cluster_name                      = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition                   = "opensearch:latest" # TODO: Replace with actual task definition ARN
  desired_count                     = 1
  container_name                    = "opensearch"
  container_port                    = 9200
  security_groups                   = [aws_security_group.opensearch-sg.id]
  load_balancer_target_group        = "" # No load balancer
  health_check_grace_period_seconds = 300 # OpenSearch takes longer to start

  tags = {
    Name        = "opensearch-service"
    Environment = "production"
    Component   = "search"
  }
}

# OpenSearch Dashboards Service
module "ecs-dashboards" {
  source = "./ecs"

  enable_ecs                   = var.enable_ecs
  service_name                 = "dashboards"
  cluster_name                 = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition              = "dashboards:latest" # TODO: Replace with actual task definition ARN
  desired_count                = 1
  container_name               = "dashboards"
  container_port               = 5601
  security_groups              = [aws_security_group.dashboards-sg.id]
  load_balancer_target_group   = var.dashboards_target_group_arn
  health_check_grace_period_seconds = 120

  tags = {
    Name        = "dashboards-service"
    Environment = "production"
    Component   = "monitoring"
  }
}

# MISP Modules Service
module "ecs-modules" {
  source = "./ecs"

  enable_ecs                        = var.enable_ecs
  service_name                      = "modules"
  cluster_name                      = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition                   = "modules:latest" # TODO: Replace with actual task definition ARN
  desired_count                     = 1
  container_name                    = "modules"
  container_port                    = 6666
  security_groups                   = [aws_security_group.modules-sg.id]
  load_balancer_target_group        = "" # No load balancer
  health_check_grace_period_seconds = 30

  tags = {
    Name        = "modules-service"
    Environment = "production"
    Component   = "enrichment"
  }
}

# Garage Service (S3-compatible storage)
module "ecs-garage" {
  source = "./ecs"

  enable_ecs                        = var.enable_ecs
  service_name                      = "garage"
  cluster_name                      = var.enable_ecs ? aws_ecs_cluster.misp-workbench[0].name : ""
  task_definition                   = "garage:latest" # TODO: Replace with actual task definition ARN
  desired_count                     = 1
  container_name                    = "garage"
  container_port                    = 3900
  security_groups                   = [aws_security_group.garage-sg.id]
  load_balancer_target_group        = "" # No load balancer
  health_check_grace_period_seconds = 60

  tags = {
    Name        = "garage-service"
    Environment = "production"
    Component   = "storage"
  }
}