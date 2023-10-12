# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13.5"
}