#  Presistent storage used for data storage
resource "aws_efs_file_system" "efs" {
  encrypted = true
  tags = {
    Name = "ECS-EFS-FS"
  }
}

# EFS Mounting 
resource "aws_efs_mount_target" "mount_a" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_default_subnet.default_subnet_a.id
  security_groups = ["${aws_security_group.service_security_group_efs.id}"]
}

resource "aws_efs_mount_target" "mount_b" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_default_subnet.default_subnet_b.id
  security_groups = ["${aws_security_group.service_security_group_efs.id}"]
}