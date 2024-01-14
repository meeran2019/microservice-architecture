resource "aws_instance" "general-ec2" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  user_data = "${file("bootstrap.sh")}"
  depends_on = [aws_eks_node_group.worker-node-group]
}