resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name        = "scalable-web-ec2-high-cpu"
  alarm_description = "Alarm when EC2 Auto Scaling Group CPU utilization is high"

  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  statistic          = "Average"
  period             = 300
  evaluation_periods = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = module.ec2.autoscaling_group_name
  }

  alarm_actions = [
    aws_sns_topic.alarm.arn
  ]

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks_low" {
  alarm_name        = "scalable-web-ecs-running-tasks-low"
  alarm_description = "Alarm when ECS service has fewer than 1 running task"

  namespace   = "ECS/ContainerInsights"
  metric_name = "RunningTaskCount"

  statistic          = "Average"
  period             = 300
  evaluation_periods = 1

  comparison_operator = "LessThanThreshold"
  threshold           = 1

  dimensions = {
    ClusterName = module.ecs.cluster_name
    ServiceName = module.ecs.service_name
  }

  alarm_actions = [
    aws_sns_topic.alarm.arn
  ]

  treat_missing_data = "breaching"
}



resource "aws_cloudwatch_metric_alarm" "rds_connection_high" {
  alarm_name        = "scalable-web-rds-high-connection"
  alarm_description = "alarm when RDS database connections are high"

  namespace   = "AWS/RDS"
  metric_name = "DatabaseConnections"

  statistic          = "Average"
  period             = 300
  evaluation_periods = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 50

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [
    aws_sns_topic.alarm.arn
  ]

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "rds_connections_high" {
  alarm_name        = "scalable-web-rds-high-connections"
  alarm_description = "Alarm when RDS database connections are high"

  namespace   = "AWS/RDS"
  metric_name = "DatabaseConnections"

  statistic          = "Average"
  period             = 300
  evaluation_periods = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 50

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [
    aws_sns_topic.alarm.arn
  ]

  treat_missing_data = "notBreaching"
}

