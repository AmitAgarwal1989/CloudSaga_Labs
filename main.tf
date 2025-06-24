resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "mysubnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myroute1" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  depends_on = [aws_internet_gateway.myigw]
}
resource "aws_route_table_association" "publicsubnet" {
  subnet_id = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myroute1.id
}
resource "aws_route_table_association" "privatesubnet" {
  subnet_id = aws_subnet.mysubnet2.id
  route_table_id = aws_vpc.myvpc.main_route_table_id
}
resource "aws_eip" "myeip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "myngw" {
  depends_on = [ aws_eip.myeip ]
  allocation_id = aws_eip.myeip.id
  subnet_id = aws_subnet.mysubnet2.id
}
resource "aws_route" "natgateway" {
  route_table_id = aws_vpc.myvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.myngw.id
  
}