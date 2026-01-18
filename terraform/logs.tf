resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/simple-backend"
  retention_in_days = 7
}
