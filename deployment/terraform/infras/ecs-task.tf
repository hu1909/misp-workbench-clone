resource "aws_ecs_task_definition" "opensearch" {
  family = "opensearch"

  container_definitions = jsonencode([{}])
}