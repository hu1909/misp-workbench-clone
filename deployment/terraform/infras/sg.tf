resource "aws_security_group" "opensearch-sg" {
  name        = "opensearch-sg"
  description = "Security group for OpenSearch cluster"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow OpenSearch API (HTTPS) from VPC"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  ingress {
    description = "Allow OpenSearch Metrics from VPC"
    from_port   = 9600
    to_port     = 9600
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "opensearch-sg"
    Service = "opensearch"
  }
}

resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg"
  description = "Security group for Frontend service"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow Traffic From LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "frontend-sg"
    Service = "frontend"
  }
}

resource "aws_security_group" "api-sg" {
  name        = "api-sg"
  description = "Security group for API service"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow API traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "api-sg"
    Service = "api"
  }
}

resource "aws_security_group" "worker-sg" {
  name        = "worker-sg"
  description = "Security group for Celery worker"
  vpc_id      = module.vpc-misp.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "worker-sg"
    Service = "worker"
  }
}

resource "aws_security_group" "beat-sg" {
  name        = "beat-sg"
  description = "Security group for Celery beat scheduler"
  vpc_id      = module.vpc-misp.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "beat-sg"
    Service = "beat"
  }
}

resource "aws_security_group" "flower-sg" {
  name        = "flower-sg"
  description = "Security group for Flower (Celery monitoring)"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow Flower UI traffic from VPC"
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "flower-sg"
    Service = "flower"
  }
}

resource "aws_security_group" "dashboards-sg" {
  name        = "dashboards-sg"
  description = "Security group for OpenSearch Dashboards"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow Dashboards UI traffic from VPC"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "dashboards-sg"
    Service = "dashboards"
  }
}

resource "aws_security_group" "modules-sg" {
  name        = "modules-sg"
  description = "Security group for MISP Modules"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow MISP modules traffic from VPC"
    from_port   = 6666
    to_port     = 6666
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "modules-sg"
    Service = "modules"
  }
}

resource "aws_security_group" "garage-sg" {
  name        = "garage-sg"
  description = "Security group for Garage (S3 storage)"
  vpc_id      = module.vpc-misp.vpc_id

  ingress {
    description = "Allow S3 API traffic from VPC"
    from_port   = 3900
    to_port     = 3900
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  ingress {
    description = "Allow Admin API traffic from VPC"
    from_port   = 3903
    to_port     = 3903
    protocol    = "tcp"
    cidr_blocks = [module.vpc-misp.cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "garage-sg"
    Service = "garage"
  }
}