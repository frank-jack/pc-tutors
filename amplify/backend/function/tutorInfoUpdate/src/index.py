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
import datetime

tableName = os.environ['STORAGE_PCTUTORSDATA_NAME']
dynamodb = boto3.resource('dynamodb')
tableUserData = dynamodb.Table(tableName)

tableName = os.environ['STORAGE_PCTUTORSREQUESTS_NAME']
dynamodb = boto3.resource('dynamodb')
tableRequestData = dynamodb.Table(tableName)

def handler(event, context):
    print('received event:')
    print(event)

    userInfo = getAllUserInfo()['Items']
    requestInfo = getAllRequestInfo()['Items']

    emailBody = "List of User Info:\n"
    for user in userInfo:
        if user['userId'] != "1":
            if user['userType'] == "Student":
                emailBody += "User Id: "+user['userId']+"\nUser Type: "+user['userType']+"\nEmail: "+user['email']+"\nName: "+user['name']+"\nGrade: "+str(user['grade'])+"\nRequests: "+", ".join(user['requests'])+"\nConnections: "+", ".join(user['connections'])+"\n\n"
            elif user['userType'] == "Tutor":
                emailBody += "User Id: "+user['userId']+"\nUser Type: "+user['userType']+"\nEmail: "+user['email']+"\nName: "+user['name']+"\nBio: "+user['bio']+"\nSubjects: "+", ".join(user['subjects'])+"\nTimes: "+", ".join(user['times'])+"\nRequests: "+", ".join(user['requests'])+"\nConnections: "+", ".join(user['connections'])+"\n\n"
    emailBody += "\nList of Request Info:\n"
    for request in requestInfo:
        emailBody += "Request Id: "+request['requestId']+"\nUser ID: "+request['userId']+"\nTutor ID: "+request['tutorId']+"\nEmail: "+request['email']+"\nName: "+request['name']+"\nGrade: "+str(request['grade'])+"\nSession Type: "+request['sessionType']+"\nSubject: "+request['subject']+"\nTimes: "+", ".join(request['times'])+"\nExpiration Time: "+request['expTime']+"\nTaken: "+request['taken']+"\nConfirmed: "+request['confirmed']+"\n\n"

    sendEmail(['alexandra.will@penncharter.com', 'owen.miner@penncharter.com', 'jack.frank@penncharter.com'], emailBody, "PC TUTORS INFO REPORT")
  
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps('Hello from your new Amplify Python lambda!')
    }

def sendEmail(toAddresses, body, subject):
    ses_client = boto3.client("ses", region_name="us-east-1")
    CHARSET = "UTF-8"

    response = ses_client.send_email(
        Destination={
            "ToAddresses": toAddresses,
        },
        Message={
            "Body": {
                "Text": {
                    "Charset": CHARSET,
                    "Data": body,
                }
            },
            "Subject": {
                "Charset": CHARSET,
                "Data": subject,
            },
        },
        Source="support@pc-tutors.com",
    )
    print(response)

def getAllUserInfo():
    response = tableUserData.scan()
    data = response['Items']
    while 'LastEvaluatedKey' in response:   
        response = tableUserData.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        data.extend(response['Items'])
    return response

def getAllRequestInfo():
    response = tableRequestData.scan()
    data = response['Items']
    while 'LastEvaluatedKey' in response:   
        response = tableRequestData.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        data.extend(response['Items'])
    return response