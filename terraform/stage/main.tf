module "resources" {
    source = "../resources"
    
    # Variables to pass through.
    env = var.env
    path_lambda_processor = var.path_lambda_processor
    path_deployment_env = var.path_deployment_env

}

