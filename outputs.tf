output "instance_public_ip" {
  value = aws_instance.minecraft-server.public_ip
}

output "instance_id" {
  value = aws_instance.minecraft-server.id
}
