output "outvodvpc" {

  description = "ID of the VPC created"
  value       = aws_vpc.vpcvod.id
}

output "outvodpubsub" {

  description = "ID of each Public subnet"
  value       = aws_subnet.vodpubsub.*.id


}




