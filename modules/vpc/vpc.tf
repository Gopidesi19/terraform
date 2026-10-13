resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "project-vpc"
    } 
}

resource "aws_subnet" "project_public_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.aws_region + "a"
    tags = {
        Name = "project-public-subnet"
    }
}

resource "aws_subnet" "project_private_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.aws_region + "b"
    tags = {
        Name = "project-private-subnet"
    }
}

resource "aws_security_group" "project_alb_sg" {
    vpc_id = aws_vpc.project_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "project-alb-sg"
    }   
}

resource "aws_alb" "project_alb" {
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.project_alb_sg.id]
    subnets = [aws_subnet.project_public_subnet.id]
    tags = {
        Name = "project-alb"
    }
}

resource "aws_internet_gateway" "project_igw" {
    vpc_id = aws_vpc.project_vpc.id
    tags = {
        Name = "project-igw"
    }
}

resource "aws_route_table" "project_public_rt" {
    vpc_id = aws_vpc.project_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project_igw.id
    }
    tags = {
        Name = "project-public-rt"
    }
}

resource "aws_route_table_association" "project_public_rt_assoc" {
    subnet_id = aws_subnet.project_public_subnet.id
    route_table_id = aws_route_table.project_public_rt.id
}

resource "aws_eip" "project_nat_eip" {
    domain = "vpc"
    tags = {
        Name = "project-nat-eip"
    }
}

resource "aws_nat_gateway" "project_nat_gw" {
    allocation_id = aws_eip.project_nat_eip.id
    subnet_id = aws_subnet.project_public_subnet.id
    tags = {
        Name = "project-nat-gw"
    }
}

resource "aws_route_table" "project_private_rt" {
    vpc_id = aws_vpc.project_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.project_nat_gw.id
    }
    tags = {
        Name = "project-private-rt"
    }
}

resource "aws_route_table_association" "project_private_rt_assoc" {
    subnet_id = aws_subnet.project_private_subnet.id
    route_table_id = aws_route_table.project_private_rt.id
}



