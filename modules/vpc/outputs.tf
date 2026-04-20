output "vpc_id" {
  description = "The ID of the vpc"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value = values(aws_subnet.public)[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = values(aws_subnet.private)[*].id
}