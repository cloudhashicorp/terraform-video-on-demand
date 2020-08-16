resource "aws_sqs_queue" "vodqueue" {

    name = var.vodqueuename
    delay_seconds = var.delaysecs
    max_message_size = var.maxmssize
    message_retention_seconds = var.msrtsecs
    receive_wait_time_seconds = var.rcwttimesecs

    tags = {
        Environment = "production"
    }
}