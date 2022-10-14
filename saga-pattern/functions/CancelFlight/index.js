const AWS = require("aws-sdk")
const ddb = new AWS.DynamoDB({ apiVersion: '2012-08-10' });

const TABLE_NAME = process.env.TABLE_NAME

exports.handler = async (event) => {
    console.log("Event: ", event)

    var params = {
        TableName: TABLE_NAME,
        Key: {
            'id': { S: event.confirmation_id }
        }
    };

    try {
        await ddb.deleteItem(params).promise();
        console.log('Success')
        return {
            statusCode: 201,
            body: "Cancel Flight Success",
        };
    } catch (error) {
        console.log('Error: ', error)
        throw new Error("ServerError")
    }
};
