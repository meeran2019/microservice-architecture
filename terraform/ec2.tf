resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_1"
  role = "ec2role "
}

resource "aws_instance" "general-ec2" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.large"
  user_data = "${file("bootstrap.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  depends_on = [aws_eks_node_group.worker-node-group]
}