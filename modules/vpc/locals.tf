locals {
  primary_nat_az = sort(tolist(var.nat_gateway_azs))[0]
}