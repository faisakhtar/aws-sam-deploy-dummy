resource "aws_resourcegroups_group" "tag_resource_group" {
  name = "poc-group"
  description = "poc resources"
  resource_query {
    type = "TAG_FILTERS_1_0"
    query = <<QUERY
    {
      "ResourceTypeFilters": ["AWS::AllSupported"],
      "TagFilters": [
        {
          "Key": "env",
          "Values": ["poc"]
        }
      ]
    }
    QUERY
  }
}