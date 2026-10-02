resource "aws_launch_template" "launch_template" {
  name_prefix   = "scalable-web-app-tpl"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.compute_sg_id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash

    dnf update -y

    dnf install -y docker

    systemctl enable docker
    systemctl start docker

    aws ecr get-login-password --region ${var.aws_region} | \
      docker login --username AWS --password-stdin ${var.ecr_repository_url}

    docker pull ${var.ecr_repository_url}:latest

    docker run -d \
      --name scalable-web-app \
      -p 80:80 \
      ${var.ecr_repository_url}:latest
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "scalable-web-app-instance"
      Environment = "dev"
    }
  }

  tags = {
    Name        = "scalable-web-app-launch-template"
    Environment = "dev"
  }
}


resource "aws_autoscaling_group" "app" {
  name = "scalable-web-app-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = [
    var.private_subnet_1a,
    var.private_subnet_1b
  ]

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type = "ELB"

  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "scalable-web-app-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}