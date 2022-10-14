const AWS = require("aws-sdk")
const ddb = new AWS.DynamoDB({ apiVersion: '2012-08-10' });

const TABLE_NAME = process.env.TABLE_NAME

class BookRentalError extends Error {
  constructor(message) {
    super(message)
    this.name = "BookRentalError"
  }
}

exports.handler = async (event) => {
  const {
    confirmation_id,
    checkin_date,
    checkout_date
  } = event

  var params = {
    TableName: TABLE_NAME,
    Item: {
      'id': { S: confirmation_id },
      'checkin_date': { S: checkin_date },
      'checkout_date': { S: checkout_date }
    }
  };

  try {
    await ddb.putItem(params).promise();
    console.log('Success')

  } catch (error) {
    console.log('Error: ', error)
    throw new Error("Unexpected Error")
  }

  if (confirmation_id.startsWith("33")) {
    throw new BookRentalError("Expected Error")
  }

  return {
    confirmation_id,
    checkin_date,
    checkout_date
  };
};
