locals {
  az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.instances), var.azs), var.instances)[0])), var.instances)[1]

}