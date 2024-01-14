resource "aws_iam_instance_profile" "ec2profile" {
  name = "ec2profile"
  role = "ec2role"
}

resource "aws_instance" "general-ec2" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.large"
  iam_instance_profile = "${aws_iam_instance_profile.ec2profile.name}"
  depends_on = [aws_eks_node_group.worker-node-group]
  user_data = templatefile("bootstrap.tpl", {
    access_key = var.access_key,
    secret_key = var.secret_key,
  })
}