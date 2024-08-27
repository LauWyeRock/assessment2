import json
import urllib3

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    response = http.request('GET', 'https://jsonplaceholder.typicode.com/users')
    users = json.loads(response.data.decode('utf-8'))

    return {
        'statusCode': 200,
        'body': json.dumps(users)
    }
