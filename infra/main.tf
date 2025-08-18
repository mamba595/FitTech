module "vpc" {
    source        = "./modules/vpc"
    vpc_cidr      = var.vpc_cidr
    public_count  = var.public_count
    private_count = var.private_count
}