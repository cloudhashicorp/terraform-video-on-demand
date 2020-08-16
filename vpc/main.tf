
resource "aws_vpc" "vpcvod" {

  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igwvod" {

  vpc_id = aws_vpc.vpcvod.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "vodpubsub" {

  count             = length(var.pubsub)
  vpc_id            = aws_vpc.vpcvod.id
  cidr_block        = var.pubsub[count.index]
  availability_zone = var.azs[count.index]

  #check needs to be done in this line for tagging
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tagspubsub,
  )
}

resource "aws_route_table" "vodroute" {

  vpc_id = aws_vpc.vpcvod.id

  tags = {

    Name = var.routename
  }
}


resource "aws_route_table_association" "vodpubsubassoc" {

  count = length(var.pubsub)

  subnet_id      = element(aws_subnet.vodpubsub.*.id, count.index)
  route_table_id = aws_route_table.vodroute.id

}


resource "aws_route" "igwvodpubrt" {

  gateway_id             = aws_internet_gateway.igwvod.id
  route_table_id         = aws_route_table.vodroute.id
  destination_cidr_block = var.wideopensub

}

resource "aws_security_group" "externallbmeet" {

  name        = var.nameexternallbmeet
  description = var.descexternallbmeet
  vpc_id      = aws_vpc.vpcvod.id


  ingress {

    from_port   = var.sgfrom_port_ingress
    to_port     = var.sgto_port_ingress
    protocol    = var.protocol_ingress
    cidr_blocks = [var.cidr_block]

  }

  egress {
    from_port   = var.sgfrom_port_egress
    to_port     = var.sgto_port_egress
    protocol    = var.protocol_egress
    cidr_blocks = [var.cidr_block]
  }

}

resource "aws_network_acl" "vodnacl" {

  vpc_id = aws_vpc.vpcvod.id

  egress {

    protocol   = var.naclprotocol_egress
    rule_no    = var.naclruleno_egress
    action     = var.naclaction_egress
    cidr_block = var.cidr_block
    from_port  = var.naclfrom_port_egress
    to_port    = var.naclto_port_egress

  }

  ingress {

    protocol   = var.naclprotocol_ingress
    rule_no    = var.naclruleno_ingress
    action     = var.naclaction_ingress
    cidr_block = var.cidr_block
    from_port  = var.naclfrom_port_ingress
    to_port    = var.naclto_port_ingress

  }

}



