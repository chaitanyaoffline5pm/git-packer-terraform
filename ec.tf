resource "aws_instance" "master" {
  count                       = length(var.public_subnet)
  ami                         = var.imagename
  key_name                    = var.key
  availability_zone           = element(var.az, count.index)
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.vpc-subnet.*.id, count.index)
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "${var.vpc_name}-Manager-${count.index + 1}"
  }

}
resource "aws_instance" "worker" {
  count                       = length(var.public_subnet)
  ami                         = var.imagename
  key_name                    = var.key
  availability_zone           = element(var.az, count.index)
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.vpc-subnet.*.id, count.index)
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "${var.vpc_name}-Worker-${count.index + 1}"
  }

}