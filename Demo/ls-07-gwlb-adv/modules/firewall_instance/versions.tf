# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

terraform {
  required_providers {
    cdo = {
      source = "CiscoDevnet/cdo"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}