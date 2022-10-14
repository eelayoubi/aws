# DynamoDB Tables
module "book_hotel_ddb" {
  source         = "./modules/dynamodb"
  table_name     = var.book_hotel_ddb_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  hash_key_type  = var.hash_key_type

  additional_tags = var.book_hotel_ddb_additional_tags
}

module "book_flight_ddb" {
  source         = "./modules/dynamodb"
  table_name     = var.book_flight_ddb_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  hash_key_type  = var.hash_key_type

  additional_tags = var.book_flight_ddb_additional_tags
}

module "book_rental_ddb" {
  source         = "./modules/dynamodb"
  table_name     = var.book_rental_ddb_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  hash_key_type  = var.hash_key_type

  additional_tags = var.book_rental_ddb_additional_tags
}

# Book Hotel Function
module "book_hotel_lambda" {
  source         = "./modules/lambda"
  function_name  = "BookHotel"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_hotel_ddb.name
  }
}

module "hotel_iam_policies" {
  source     = "./modules/iam-policies"
  name       = "hotel_dynamo_db"
  table_name = module.book_hotel_ddb.name
}

resource "aws_iam_role_policy_attachment" "book_hotel_lambda_dynamo_db_write" {
  role       = module.book_hotel_lambda.function_role_name
  policy_arn = module.hotel_iam_policies.dynamo_db_write
}

# Book Flight Function
module "book_flight_lambda" {
  source         = "./modules/lambda"
  function_name  = "BookFlight"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_flight_ddb.name
  }
}

module "flight_iam_policies" {
  source     = "./modules/iam-policies"
  name       = "flight_dynamo_db"
  table_name = module.book_flight_ddb.name
}

resource "aws_iam_role_policy_attachment" "book_flight_lambda_dynamo_db_write" {
  role       = module.book_flight_lambda.function_role_name
  policy_arn = module.flight_iam_policies.dynamo_db_write
}

# Book Rental Function
module "book_rental_lambda" {
  source         = "./modules/lambda"
  function_name  = "BookRental"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_rental_ddb.name
  }
}

module "rental_iam_policies" {
  source     = "./modules/iam-policies"
  name       = "rental_dynamo_db"
  table_name = module.book_rental_ddb.name
}

resource "aws_iam_role_policy_attachment" "book_rental_lambda_dynamo_db_write" {
  role       = module.book_rental_lambda.function_role_name
  policy_arn = module.rental_iam_policies.dynamo_db_write
}

# Cancel Hotel Function
module "cancel_hotel_lambda" {
  source         = "./modules/lambda"
  function_name  = "CancelHotel"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_hotel_ddb.name
  }
}

resource "aws_iam_role_policy_attachment" "cancel_hotel_lambda_dynamo_db_delete" {
  role       = module.cancel_hotel_lambda.function_role_name
  policy_arn = module.hotel_iam_policies.dynamo_db_delete
}

# Cancel Flight Function
module "cancel_flight_lambda" {
  source         = "./modules/lambda"
  function_name  = "CancelFlight"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_flight_ddb.name
  }
}

resource "aws_iam_role_policy_attachment" "cancel_flight_lambda_dynamo_db_delete" {
  role       = module.cancel_flight_lambda.function_role_name
  policy_arn = module.flight_iam_policies.dynamo_db_delete
}

# Cancel Rental Function
module "cancel_rental_lambda" {
  source         = "./modules/lambda"
  function_name  = "CancelRental"
  lambda_handler = "index.handler"
  environment_variables = {
    "TABLE_NAME" = module.book_rental_ddb.name
  }
}

resource "aws_iam_role_policy_attachment" "cancel_rental_lambda_dynamo_db_delete" {
  role       = module.cancel_rental_lambda.function_role_name
  policy_arn = module.rental_iam_policies.dynamo_db_delete
}

# Step Function
module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name = "Reservation"

  definition = templatefile("${path.module}/state-machine/reservation.asl.json", {
    BOOK_HOTEL_FUNCTION_ARN    = module.book_hotel_lambda.function_arn,
    CANCEL_HOTEL_FUNCTION_ARN  = module.cancel_hotel_lambda.function_arn,
    BOOK_FLIGHT_FUNCTION_ARN   = module.book_flight_lambda.function_arn,
    CANCEL_FLIGHT_FUNCTION_ARN = module.cancel_flight_lambda.function_arn,
    BOOK_RENTAL_LAMBDA_ARN     = module.book_rental_lambda.function_arn,
    CANCEL_RENTAL_LAMBDA_ARN   = module.cancel_rental_lambda.function_arn
  })

  service_integrations = {
    lambda = {
      lambda = [
        module.book_hotel_lambda.function_arn,
        module.book_flight_lambda.function_arn,
        module.book_rental_lambda.function_arn,
        module.cancel_hotel_lambda.function_arn,
        module.cancel_flight_lambda.function_arn,
        module.cancel_rental_lambda.function_arn,
      ]
    }
  }

  type = "STANDARD"
}