resource "aws_security_group" "elasticsearch" {
  name                    = "${var.team}-${var.environment}-elasticsearch-sg"
  description             = "Elasticsearch VPC Security Group"
  vpc_id                  = aws_vpc.vpc.id
  revoke_rules_on_delete  = true

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.vpc.cidr_block
    ]
  }
}

output "elasticsearch_security_group_ids" {
  value = [aws_security_group.elasticsearch.id]
}
