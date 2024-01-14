resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  node_group_name = "workernodes"
  node_role_arn  = "arn:aws:iam::346464389794:role/eks-node-group-example"
  subnet_ids   = [var.subnet_id_1, var.subnet_id_2]
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

