import json


def construct_name(first_name, last_name):
    constructed_name = ''
    if first_name:
        constructed_name = first_name
    if last_name:
        if first_name:
            constructed_name += ' '
        constructed_name += last_name
    return constructed_name or 'Anonymous'


def create_message(first_name, last_name, age):
    age_text = ''
    if age:
        age_text = ' {} year old'.format(age)
    message = 'Hello {}, you{} genius!'.format(construct_name(first_name, last_name), age_text)
    return {
        'message': message
    }


def generate_lambda_proxy_response(status_code, message):
    return {
        "isBase64Encoded": False,
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(message)
    }


def clean_param(p):
    return p or ''


def lambda_handler(event, context):

    first_name = clean_param(event.get('first_name'))
    last_name = clean_param(event.get('last_name'))
    age = clean_param(event.get('age'))

    message = create_message(first_name, last_name, age)
    print(message)
    response = generate_lambda_proxy_response(200, message)
    return response
