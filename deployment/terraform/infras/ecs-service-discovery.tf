resource "aws_service_discovery_private_dns_namespace" "misp-workbench-namespace" {
  name = "misp-workbench-namespace"
  vpc  = module.vpc-misp.vpc_id
}


resource "aws_service_discovery_service" "misp-workbench-dns-service" {
  name = "misp-workbench-dns-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.misp-workbench-namespace.id

    dns_records {
      ttl  = 10 
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}