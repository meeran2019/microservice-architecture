resource "aws_eks_cluster" "eks-cluster" {
 name = "eks-cluster"
 role_arn = "arn:aws:iam::346464389794:role/eks-iam-role"

 vpc_config {
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}