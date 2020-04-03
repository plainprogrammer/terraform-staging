resource "aws_elasticache_parameter_group" "memcache-param-group" {
  name   = "memcache-params"
  family = "memcached1.5"
}

resource "aws_elasticache_cluster" "memcache" {
  cluster_id            = "${var.team}-${var.environment}-memcache"
  engine                = "memcached"
  node_type             = "cache.m4.large"
  num_cache_nodes       = 2
  parameter_group_name  = "memcache-params"
  subnet_group_name     = aws_elasticache_subnet_group.cache-subnet.name

  tags = {
    Team = var.team
  }
}
