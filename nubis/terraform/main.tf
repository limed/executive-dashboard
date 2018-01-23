module "worker" {
  source        = "github.com/nubisproject/nubis-terraform//worker?ref=v2.0.4"
  region        = "${var.region}"
  environment   = "${var.environment}"
  account       = "${var.account}"
  service_name  = "${var.service_name}"
  purpose       = "webserver"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  min_instances = "1"
  wait_for_capacity_timeout = "20m"
}
