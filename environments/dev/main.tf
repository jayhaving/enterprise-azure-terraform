# ------------------------------------------------------------------------------
# ENTERPRISE IAM & INFRASTRUCTURE ENVIRONMENT INSTANTIATION
# ------------------------------------------------------------------------------

module "iam" {
  source          = "../../modules/iam"
  environment     = var.environment
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

module "network" {
  source      = "../../modules/network"
  environment = var.environment
  location    = var.location
}

module "security" {
  source      = "../../modules/security"
  environment = var.environment
  location    = var.location
}

module "keyvault" {
  source      = "../../modules/keyvault"
  environment = var.environment
  location    = var.location
  vnet_id     = module.network.spoke_vnet_id
  subnet_id   = module.network.spoke_db_subnet_id
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
  location    = var.location
  subnet_id   = module.network.spoke_db_subnet_id
}

module "compute" {
  source       = "../../modules/compute"
  environment  = var.environment
  location     = var.location
  subnet_id    = module.network.spoke_app_subnet_id
  key_vault_id = module.keyvault.key_vault_id
}
