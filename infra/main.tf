resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "devops-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "public-subnet" }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-01b14b7ad41e17ba4" # Amazon Linux 2 free tier
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  tags = { Name = "JenkinsServer" }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"   # ✅ stable release

  cluster_name    = "devops-cluster"
  cluster_version = "1.27"
  vpc_id          = aws_vpc.main.id
  subnet_ids      = [aws_subnet.public.id]

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_types = ["t3.micro"]
    }
  }
}
