from unittest import TestCase
from hello import lambda_handler
import json


class TestEventGeneration(TestCase):

    def test_event_valid(self):
        valid_event_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello John Smith, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler({
            "first_name": "John",
            "last_name": "Smith",
            "age": 25
        }, None)

        self.assertEqual(valid_event_response, lambda_output)

    def test_event_missing_firstname(self):
        missing_firstname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Smith, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler({
            "random_key": "John",
            "last_name": "Smith",
            "age": 25
        }, None)

        self.assertEqual(missing_firstname_response, lambda_output)

    def test_event_missing_lastname(self):
        missing_lastname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello John, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler({
            "first_name": "John",
            "random_key": "Smith",
            "last_name": "",
            "age": 25
        }, None)

        self.assertEqual(missing_lastname_response, lambda_output)

    def test_event_missing_wholename(self):
        missing_firstname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Anonymous, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler({
            "random_key": "",
            "last_name": "",
            "age": 25
        }, None)

        self.assertEqual(missing_firstname_response, lambda_output)