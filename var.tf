variable "region" {

    type = string
    default ="ap-south-1"

}
 variable  "ami" {
type=string
default ="ami-0bcf5425cdc1d8a85"
}

variable "instance_type"{
type= string
default ="t2.micro"
}

variable "subnet"{
type=  list

//you want to lauch multiple instances in  different AZ, dd below

default =["subnet-0b241e83c745d077f","subnet-080820b5aecb4c32d"]

}

