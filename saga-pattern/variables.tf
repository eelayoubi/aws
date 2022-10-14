variable "book_hotel_ddb_name" {
  type    = string
  default = "BookHotel"
}

variable "book_flight_ddb_name" {
  type    = string
  default = "BookFlight"
}

variable "book_rental_ddb_name" {
  type    = string
  default = "BookRental"
}

variable "billing_mode" {
  type    = string
  default = "PROVISIONED"
}

variable "read_capacity" {
  type    = number
  default = 5
}

variable "write_capacity" {
  type    = number
  default = 5
}

variable "hash_key" {
  type    = string
  default = "id"
}

variable "hash_key_type" {
  type    = string
  default = "S"
}

variable "book_hotel_ddb_additional_tags" {
  type = map(string)
  default = {
    Name = "BookHotel"
  }
}

variable "book_flight_ddb_additional_tags" {
  type = map(string)
  default = {
    Name = "BookFlight"
  }
}

variable "book_rental_ddb_additional_tags" {
  type = map(string)
  default = {
    Name = "BookRental"
  }
}