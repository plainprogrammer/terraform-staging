resource "aws_elasticache_parameter_group" "redis-param-group" {
  name   = "redis-cache-params"
  family = "redis3.2"
}

resource "aws_elasticache_cluster" "snowpeople-redis" {
  cluster_id            = "${var.team}-${var.environment}-redis"
  engine                = "redis"
  engine_version        = "3.2.4"
  node_type             = "cache.m4.large"
  num_cache_nodes       = 1
  parameter_group_name  = "redis-cache-params"
  subnet_group_name     = aws_elasticache_subnet_group.cache-subnet.name

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}
