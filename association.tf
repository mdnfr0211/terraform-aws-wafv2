resource "aws_wafv2_web_acl_association" "alb" {
  count = var.create_alb_association && length(var.alb_arn_list) > 0 ? length(var.alb_arn_list) : 0

  resource_arn = var.alb_arn_list[count.index]
  web_acl_arn  = aws_wafv2_web_acl.main.arn

  depends_on = [aws_wafv2_web_acl.main]
}

resource "aws_wafv2_web_acl_association" "apigw" {
  count = var.create_apigw_association && length(var.apigw_arn_list) > 0 ? length(var.apigw_arn_list) : 0

  resource_arn = var.apigw_arn_list[count.index]
  web_acl_arn  = aws_wafv2_web_acl.main.arn

  depends_on = [aws_wafv2_web_acl.main]
}
