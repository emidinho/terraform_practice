output "lbarn" {
  value = aws_lb.test.arn
}

output "lburl" {
  value=aws_lb.test.dns_name
}