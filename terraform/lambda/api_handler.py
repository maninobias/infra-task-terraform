def handler(event, context):
    print("Hello from the API Lambda!")
    return {
        'statusCode': 200,
        'body': 'Hello from the API Lambda!'
    }