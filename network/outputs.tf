output "subnet_ids" {
  value = [
    aws_subnet.databases-az1.id,
    aws_subnet.databases-az2.id,
    aws_subnet.databases-az3.id
  ]
}

output "security_group_ids" {
  value = [aws_security_group.bigmaven-sg.id]
}
