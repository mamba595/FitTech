resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public" {
    count = var.public_count
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    map_public_ip_on_launch = true
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        Name = "public-${count.index}
    }
}

resource "aws_subnet" "private" {
    count             = var.private_count
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_count)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        Name = "private-${count.index}
    }
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "vpc-igw"
    }
}

resource "aws_eip" "nat" {
    count = var.public_count
    vpc   = true
}

resource "aws_nat_gateway" "ngw" {
    count         = var.public_count
    allocation_id = aws_eip.nat[count.index].id
    subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_lb" "alb" {
    name               = "alb"
    internal           = false
    load_balancer_type = "application"
    subnets            = aws_subnet.public[*].id
}

resource "aws_ecs_cluster" "cluster" {
    name = "cluster"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

resource "aws_iam_role" "ecs_task_role" {
    name = "ecs_task_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect    = "Allow"
            Principal = { Service = "ecs-tasks.amazonaws.com" }
            Action    = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
    role       = aws_iam_role.ecs_task_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "api_task" {
    family                  = "api_task"
    network_mode            = "awsvpc"
    requires_compatibilites = ["FARGATE"]
    cpu                     = "256"
    memory                  = "512"
    execution_role_arn      = aws_iam_role.ecs_task_role.arn
    task_role_arn           = aws_iam_role.ecs_task_role.arn

    container_definitions = jsonencode([
        {
            name = "api"
            image = ""
            cpu = 256
            memory = 512
            essential = true
            portMappings = [{ 
                containerPort = 3000,
                hostPort = 3000
            }]
            environment = [
                {
                    name = "DATABASE_URL",
                    value = ""
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "api_service" {
    name = "api
}