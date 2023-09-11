resource "aws_iam_role" "cluster_role" {
  name = "msa-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_AmazonEKSClusterPolicy_to_Role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}
resource "aws_iam_role_policy_attachment" "attach_AmazonEKSVPCResourceController_to_Role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}


resource "aws_eks_cluster" "msa_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  enabled_cluster_log_types = ["api", "audit", "controllerManager"]

  vpc_config {
    subnet_ids = [
      aws_subnet.msa_public_private_a.id,
      aws_subnet.msa_public_private_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.attach_AmazonEKSClusterPolicy_to_Role,
    aws_iam_role_policy_attachment.attach_AmazonEKSVPCResourceController_to_Role
  ]

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = element(split("/", data.aws_caller_identity.current.arn), 1)
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}