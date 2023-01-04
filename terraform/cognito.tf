# Create a Cognito user pool
resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "integration_user_pool"
}



# Create a Cognito user pool client
resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name                = "integration_user_pool_client"
  user_pool_id        = aws_cognito_user_pool.cognito_user_pool.id
  generate_secret     = true
  allowed_oauth_flows = ["client_credentials"]
  supported_identity_providers = ["COGNITO"]
}


