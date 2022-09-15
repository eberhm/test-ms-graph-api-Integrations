module "oidc_provider" {
  source            = "git@github.com:onlyfyio/terraform-modules//oidc-provider?ref=v1.1.0"
  region            = var.region
  environment       = var.environment
  github_repository = var.github_repository
}
