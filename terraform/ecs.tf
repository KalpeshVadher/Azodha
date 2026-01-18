resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/simple-backend"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "this" {
  name = "simple-backend-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name   = "ecs-backend-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "simple-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = "${var.ecr_repo_url}:latest"

      portMappings = [{
        containerPort = 50000
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/simple-backend"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 50000
  }

  depends_on = [aws_lb_listener.http]
}
