locals {
  default_template_path = "${path.module}/default-user_data.tpl"
  template_path         = "${var.template_path != "" ? var.template_path : local.default_template_path}"
}