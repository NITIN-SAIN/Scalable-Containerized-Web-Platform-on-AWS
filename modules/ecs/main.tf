resource "aws_ecs_cluster" "ecs_cluster" {
  name = "scalable-web-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "scalable-web-ecs-cluster"
    Environment = "dev"
  }

}

resource "aws_ecs_task_definition" "ecs_tast_def" {
  family                   = "scalable-web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "scalable-web-app"
      image     = "${var.ecr_repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/scalable-web-app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "scalable-web-app-task-definition"
    Environment = "dev"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "scalable-web-ecs-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ecs_tast_def.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      var.private_subnet_1a,
      var.private_subnet_1b
    ]

    security_groups = [
      var.compute_sg_id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.ecs_target_group_arn
    container_name   = "scalable-web-app"
    container_port   = 80
  }

  tags = {
    Name        = "scalable-web-ecs-service"
    Environment = "dev"
  }

  depends_on = [
    var.ecs_listener_rule_arn
  ]
}