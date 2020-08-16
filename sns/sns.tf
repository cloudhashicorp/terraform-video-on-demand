resource "aws_sns_topic" "vodprocessing" {

    name = var.snsname

    delivery_policy = var.delpolicy
    
}