variable "save_to" {
  default = ""
}

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = "${path.module}/../resource-manager/cisco-asa.zip"
  source_dir  = "../"
  excludes    = ["terraform.tfstate", "terraform.tfvars.template", "terraform.tfvars", "provider.tf", ".terraform", "build-orm", "images", "README.md", "terraform.", "terraform.tfstate.backup", "test", "simple", ".git", "README", ".github", ".gitignore", ".DS_Store", "LICENSE", "resource-manager", "config-ha"] 
}
