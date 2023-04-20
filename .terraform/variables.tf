# Remember to adjust .github/workflows/main.yml

variable "git_repository" {
  type = string
  description = "The name of the current git repository"
  default = "homepage"
}

variable "git_branch" {
  type        = string
  description = "The current git branch. On a dev's machine it would be develop"
  default = "develop"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website. If the website is www.example.com this value would be example.com"
  default = "codefab.io"
}

variable "region" {
  type        = string
  description = "Region for our region-optional resources"
  default     = "eu-central-1"
}

variable "common_tags" {
  description = "Common tags you want applied to all resources"
}
