from urllib import request, parse
import urllib
import os
import json
import base64
import boto3
import uuid
from datetime import datetime
from boto3.dynamodb.conditions import Key, Attr
import random
import ast

tableName = os.environ['STORAGE_PCTUTORSDATA_NAME']
dynamodb = boto3.resource('dynamodb')
tableUserData = dynamodb.Table(tableName)

def handler(event, context):
    print('received event:')
    print(event)
    if 'GET' in event['httpMethod']:
        print(list(event['queryStringParameters'].keys())[list(event['queryStringParameters'].values()).index('')])
        response = getUserInfo(list(event['queryStringParameters'].keys())[list(event['queryStringParameters'].values()).index('')])
        if len(response['Items']):
            response['Items'][0]['grade'] = int(response['Items'][0]['grade'])
        print(response)
    if 'POST' in event['httpMethod']:
        body = json.loads(event['body'])
        response = addUserInfo(body['userId'], body['email'], body['userType'], body['name'], int(body['grade']), body['bio'], ast.literal_eval(body['subjects']), ast.literal_eval(body['times']), ast.literal_eval(body['requests']), ast.literal_eval(body['connections']))
    if 'PUT' in event['httpMethod']:
        body = json.loads(event['body'])
        response = updateUserInfo(body['userId'], body['email'], body['userType'], body['name'], int(body['grade']), body['bio'], ast.literal_eval(body['subjects']), ast.literal_eval(body['times']), ast.literal_eval(body['requests']), ast.literal_eval(body['connections']))
 

  
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps(response)
    }

def addUserInfo(userId, email, userType, name, grade, bio, subjects, times, requests, connections):
    response = tableUserData.put_item(
        Item={
            'userId': userId,
            'email': email,
            'userType': userType,
            'name': name,
            'grade': grade,
            'bio': bio,
            'subjects': subjects,
            'times': times,
            'requests': requests,
            'connections': connections
        }
    )
    return response

def updateUserInfo(userId, email, userType, name, grade, bio, subjects, times, requests, connections):
    response = tableUserData.delete_item(
        Key={
            'userId': userId,
        }
    )
    response = tableUserData.put_item(
        Item={
            'userId': userId,
            'email': email,
            'userType': userType,
            'name': name,
            'grade': grade,
            'bio': bio,
            'subjects': subjects,
            'times': times,
            'requests': requests,
            'connections': connections
        }
    )
    return response

def getUserInfo(userId):
    response = tableUserData.query(KeyConditionExpression=Key('userId').eq(userId))
    return response

