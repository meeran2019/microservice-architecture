resource "aws_instance" "example" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
}