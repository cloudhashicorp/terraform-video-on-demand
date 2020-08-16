############################################################
#Author   : Darwin Panela                                  #
#LinkedIn : https://www.linkedin.com/in/darwinpanelacloud/ #
#github   : https://github.com/cloudhashicorp              #
############################################################


#####
#VPC#
#####

module "vpcmod" {
  source = "./vpc"

  name               = "vodProj Public Subnet"
  cidr_block         = "10.0.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  pubsub             = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  routename          = "vod Public Route"
  wideopensub        = "0.0.0.0/0"
  nameexternallbmeet = "allow_443"
  descexternallbmeet = "Allow TLS Inbound traffic"

  protocol_ingress    = "tcp"
  sgfrom_port_ingress = 443
  sgto_port_ingress   = 443
  protocol_egress     = "-1"
  sgfrom_port_egress  = 0
  sgto_port_egress    = 0

  naclprotocol_egress  = "tcp"
  naclruleno_egress    = 200
  naclaction_egress    = "allow"
  naclfrom_port_egress = 0
  naclto_port_egress   = 65535

  naclprotocol_ingress  = "tcp"
  naclruleno_ingress    = 100
  naclaction_ingress    = "allow"
  naclfrom_port_ingress = 443
  naclto_port_ingress   = 443




  tagspubsub = {
    Owner       = "VideoOnDemand"
    Environment = "Production"
    Name        = "Public Subnet"

  }


}

module "s3mod" {

  source          = "./s3"
  bucket_name     = "vodsources3"
  acl             = "private"
  version_enabled = "true"
  days            = 20
  id              = "inputlifecycle"
  prefix          = "sourcevid/"
  siadays         = 30
  gladays         = 60
  sia             = "STANDARD_IA"
  gla             = "GLACIER"
  noncurrentdays  = 120
  lifecyclerule   = "true"
}

module "iammod" {

  source = "./iam"

}

module "dbmod" {

  source    = "./db"
  voddbname = "VodNameofVid"
  dbbilling = "PAY_PER_REQUEST"
  readcap   = 30
  writecap  = 30
  hkey      = "guid"
  rkey      = "srcBucket"
  atttype   = "S"

}

module "snsmod" {

  source    = "./sns"
  snsname = "vod-processing"
  delpolicy = <<EOF
    {
        "http": {
            "defaultHealthyRetryPolicy": {
                "minDelayTarget": 30,
                "maxDelayTarget": 30,
                "numRetries": 5,
                "numMaxDelayRetries": 0,
                "numNoDelayRetries": 0,
                "numMinDelayRetries": 0,
                "backoffFunction": "linear"
                },
                "disableSubscriptionOverrides": false,
                "defaultThrottlePolicy": {
                    "maxReceivesPerSecond":1
                }
            }
        }
        EOF

}

module "sqsmod" {

  source = "./sqs"
  vodqueuename = "vod-delivery-queue"
  delaysecs = 60
  maxmssize = 1024
  msrtsecs = 86400
  rcwttimesecs = 20
}


module "cloudfrontmod" {

  source = "./cloudfront"
}


