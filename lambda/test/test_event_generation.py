from unittest import TestCase
from hello import lambda_handler
import json
import logging
import sys

logger = logging.getLogger()
logger.level = logging.ERROR


class TestEventGeneration(TestCase):

    def setUp(self):
        stream_handler = logging.StreamHandler(sys.stdout)
        logger.addHandler(stream_handler)

    def assembleEventPayload(self, contents):
        return {"queryStringParameters": contents}

    def test_event_valid(self):
        valid_event_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello John Smith, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "first_name": "John",
            "last_name": "Smith",
            "age": 25
        }), None)

        self.assertEqual(valid_event_response, lambda_output)

    def test_event_missing_firstname(self):
        missing_firstname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Smith, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "random_key": "John",
            "last_name": "Smith",
            "age": 25
        }), None)

        self.assertEqual(missing_firstname_response, lambda_output)

    def test_event_missing_lastname(self):
        missing_lastname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello John, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "first_name": "John",
            "random_key": "Smith",
            "age": 25
        }), None)

        self.assertEqual(missing_lastname_response, lambda_output)

    def test_event_missing_wholename(self):
        missing_firstname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Anonymous, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "random_key": "",
            "another_random_key": "",
            "age": 25
        }), None)

        self.assertEqual(missing_firstname_response, lambda_output)

    def test_event_blank_wholename(self):
        missing_firstname_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Anonymous, you 25 year old genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "first_name": "",
            "last_name": "",
            "age": 25
        }), None)

        self.assertEqual(missing_firstname_response, lambda_output)

    def test_event_missing_age(self):
        missing_age_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello John Smith, you genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "first_name": "John",
            "last_name": "Smith",
            "random_key": 25
        }), None)

        self.assertEqual(missing_age_response, lambda_output)

    def test_event_missing_all(self):
        missing_all_response = json.loads(
            r'{"isBase64Encoded": false, "statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": "{\"message\": \"Hello Anonymous, you genius!\"}"}')

        lambda_output = lambda_handler(self.assembleEventPayload({
            "random1": "blah",
            "random2": "blah",
            "random3": 0
        }), None)

        self.assertEqual(missing_all_response, lambda_output)
