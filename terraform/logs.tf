resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/simple-backend"
  retention_in_days = 7

  lifecycle {
    prevent_destroy = false      # safe destroy
    ignore_changes  = [name]     # agar log group already exist, ignore
  }
}
