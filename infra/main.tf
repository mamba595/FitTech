module "vpc" {
    source        = "./modules/vpc"
    vpc_cidr      = var.vpc_cidr
    public_count  = var.public_count
    private_count = var.private_count
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    image = var.image
}