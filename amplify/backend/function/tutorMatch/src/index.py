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
    
    userInfo = getAllUserInfo()
    print(userInfo)
    response = ""
    
    if 'httpMethod' not in event:
        requestInfo = getAllRequestInfo()
        for request in requestInfo['Items']:
            if len(request['expTime']) != 0:
                expTime = request['expTime'].split(" ")
                newHour = datetime.datetime.now().hour-4
                newDay = datetime.datetime.now().day
                if newHour < 0:
                    newHour = newHour+24
                    newDay = newDay-1
                now = datetime.datetime(datetime.datetime.now().year, datetime.datetime.now().month, newDay, newHour, datetime.datetime.now().minute, datetime.datetime.now().second)
                expTimeDate = datetime.datetime(int(expTime[0]), int(expTime[1]), int(expTime[2]), int(expTime[3]), int(expTime[4]), int(expTime[5]))
                if expTimeDate < now:
                    response = request['requestId']+" is expired"
                    connectedEmail = getUserInfo(request['tutorId'])['Items'][0]['email']
                    sendEmail([request['email'], connectedEmail, 'alexandra.will@penncharter.com', 'owen.miner@penncharter.com'], "This tutoring request has expired becuase the student did not confirm that the tutor contacted them within 24 hours.\n\nRequest ID: "+request['requestId'], "TUTORING REQUEST EXPIRED")
                    for user in userInfo['Items']:
                        if request['requestId'] in user['connections']:
                            user['connections'].remove(request['requestId'])
                            updateUserInfo(user['userId'], user['email'], user['userType'], user['name'], int(user['grade']), user['bio'], user['subjects'], user['times'], user['requests'], user['connections'])
                    updateRequestInfo(request['requestId'], request['userId'], request['email'], request['name'], int(request['grade']), request['subject'], request['times'], request['sessionType'], "", 'false', request['confirmed'], "")
                else:
                    response = request['requestId']+" is not expired"
                print(response)
    elif 'GET' in event['httpMethod']:
        print(list(event['queryStringParameters'].keys())[list(event['queryStringParameters'].values()).index('')])
        response = getRequestInfo(list(event['queryStringParameters'].keys())[list(event['queryStringParameters'].values()).index('')])
        if len(response['Items']):
            response['Items'][0]['grade'] = int(response['Items'][0]['grade'])
            if response['Items'][0]['taken'] == 'false':
                response['Items'][0]['taken'] = False
            else:
                response['Items'][0]['taken'] = True
            if response['Items'][0]['confirmed'] == 'false':
                response['Items'][0]['confirmed'] = False
            else:
                response['Items'][0]['confirmed'] = True
        print(response)
    elif 'POST' in event['httpMethod']:
        body = json.loads(event['body'])
        tutors = []
        tutorAccounts = []
        if body['userId'] != 'dd14240c-1966-44bb-a8ec-16de01f7d5b2':
            for account in userInfo['Items']:
                if account['userType'] == 'Tutor':
                    if body['subject'] in account['subjects']:
                        for studentTime in ast.literal_eval(body['times']):
                            if studentTime in account['times']:
                                if account not in tutorAccounts:
                                    tutors.append(account['email'])
                                    tutorAccounts.append(account)
            print(tutors)
            if len(tutors) != 0:
                tutors.append('alexandra.will@penncharter.com')
                tutors.append('owen.miner@penncharter.com')
                sendEmail(tutors, "A new student in grade "+body['grade']+" needs tutoring in "+body['subject']+"! Go to PC Tutors to sign up to tutor this student! Rememeber: ONLY the first tutor to sign up in PC Tutors will be matched with this student.\n\nRequest ID: "+body['requestId'], "PC TUTORING: New Student Availiable!")
                sendEmail([body['email']], str(len(tutors))+" tutor(s) have been contacted with your tutoring request.\n\nRequest ID: "+body['requestId'], "TUTORS CONTACTED")
                response = addRequestInfo(body['requestId'], body['userId'], body['email'], body['name'], int(body['grade']), body['subject'], ast.literal_eval(body['times']), body['sessionType'], "", 'false', 'false', "")
                studentInfo = getUserInfo(body['userId'])['Items'][0]
                studentInfo['requests'].append(body['requestId'])
                updateUserInfo(body['userId'], studentInfo['email'], studentInfo['userType'], studentInfo['name'], int(studentInfo['grade']), studentInfo['bio'], studentInfo['subjects'], studentInfo['times'], studentInfo['requests'], studentInfo['connections'])
            else:
                sendEmail([body['email'], 'alexandra.will@penncharter.com', 'owen.miner@penncharter.com'], "No tutors are currently availiable with the specifications of your request. Wait for contact from an administrator. \n\nRequest ID: "+body['requestId'], "NO TUTORS AVAILIABLE")
            for tutor in tutorAccounts:
                tutor['requests'].append(body['requestId'])
                updateUserInfo(tutor['userId'], tutor['email'], tutor['userType'], tutor['name'], int(tutor['grade']), tutor['bio'], tutor['subjects'], tutor['times'], tutor['requests'], tutor['connections'])
        else:
            sendEmail([body['email']], "Sign Up to connect with a tutor.", "PC Tutors Alert")
    elif 'PUT' in event['httpMethod']:
        body = json.loads(event['body'])
        if body['confirmed'] == 'false':
            studentInfo = getUserInfo(body['userId'])['Items'][0]
            tutorInfo = getUserInfo(body['tutorId'])['Items'][0]
            print(studentInfo)
            print(tutorInfo)
            studentInfo['connections'].append(body['requestId'])
            tutorInfo['connections'].append(body['requestId'])
            updateUserInfo(body['userId'], studentInfo['email'], studentInfo['userType'], studentInfo['name'], int(studentInfo['grade']), studentInfo['bio'], studentInfo['subjects'], studentInfo['times'], studentInfo['requests'], studentInfo['connections'])
            updateUserInfo(body['tutorId'], tutorInfo['email'], tutorInfo['userType'], tutorInfo['name'], int(tutorInfo['grade']), tutorInfo['bio'], tutorInfo['subjects'], tutorInfo['times'], tutorInfo['requests'], tutorInfo['connections'])
            sendEmail([studentInfo['email']], "You have been matched with a tutor. You should recieve an email from this tutor at "+tutorInfo['email']+" within the next 24 hours.\n\nOnce you recieve an email from your tutor go to the PC Tutors app, then to the Connections Page, and finally click on the RED (!) for the correct connection. This is NECESSARY and will confirm your tutoring connection.\n\nRequest ID: "+body['requestId'], "MATCHED WITH A TUTOR")
            sendEmail([tutorInfo['email']], "You have been matched with a student. You have 24 hours to send an email to this student at "+studentInfo['email']+" or they will be matched with another tutor.\n\nIn your email, remind your student to go to the PC Tutors app, then to the Connections Page, and finally click on the RED (!) for the correct connection. This is NECESSARY and will confirm your tutoring connection.\n\nRequest ID: "+body['requestId'] ,"MATCHED WITH A STUDENT")
            newHour = datetime.datetime.now().hour-4
            newDay = datetime.datetime.now().day
            if newHour < 0:                    
                newHour = newHour+24
                newDay = newDay-1
            now = datetime.datetime(datetime.datetime.now().year, datetime.datetime.now().month, newDay, newHour, datetime.datetime.now().minute, datetime.datetime.now().second)
            expTimeDate = now + datetime.timedelta(days = 1)
            expTime = str(expTimeDate.year)+" "+str(expTimeDate.month)+" "+str(expTimeDate.day)+" "+str(expTimeDate.hour)+" "+str(expTimeDate.minute)+" "+str(expTimeDate.second)
            print(expTime)
            response = updateRequestInfo(body['requestId'], body['userId'], body['email'], body['name'], int(body['grade']), body['subject'], ast.literal_eval(body['times']), body['sessionType'], body['tutorId'], body['taken'], body['confirmed'], expTime)
        else:
            response = updateRequestInfo(body['requestId'], body['userId'], body['email'], body['name'], int(body['grade']), body['subject'], ast.literal_eval(body['times']), body['sessionType'], body['tutorId'], body['taken'], body['confirmed'], "")
            connectedEmail = getUserInfo(body['tutorId'])['Items'][0]['email']
            sendEmail([connectedEmail, 'alexandra.will@penncharter.com', 'owen.miner@penncharter.com'], "Your student has confirmed your tutoring connection. Now that your tutoring connection is confirmed, remember to frequently email your student and always email them with a reminder at least 12 hours before any tutoring session. \n\nRequest ID: "+body['requestId'], "TUTORING CONNECTION CONFIRMED")
    elif 'DELETE' in event['httpMethod']:
        requestId = list(event['queryStringParameters'].keys())[list(event['queryStringParameters'].values()).index('')]
        request = getRequestInfo(requestId)['Items'][0]
        connectedEmail = getUserInfo(request['tutorId'])['Items'][0]['email']
        sendEmail([request['email'], connectedEmail, 'alexandra.will@penncharter.com', 'owen.miner@penncharter.com'], "This tutoring connection has been deleted.\n\nRequest ID: "+request['requestId'], "TUTORING CONNECTION DELETED")
        response = deleteRequestInfo(requestId)
        for account in userInfo['Items']:
            if requestId in account['connections']:
                account['connections'].remove(requestId)
            if requestId in account['requests']:
                account['requests'].remove(requestId)
            updateUserInfo(account['userId'], account['email'], account['userType'], account['name'], int(account['grade']), account['bio'], account['subjects'], account['times'], account['requests'], account['connections'])

            


    

        

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps(response)
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

def addRequestInfo(requestId, userId, email, name, grade, subject, times, sessionType, tutorId, taken, confirmed, expTime):
    response = tableRequestData.put_item(
        Item={
            'requestId': requestId,
            'userId': userId,
            'email': email,
            'name': name,
            'grade': grade,
            'subject': subject,
            'times': times,
            'sessionType': sessionType,
            'tutorId': tutorId,
            'taken': taken,
            'confirmed': confirmed,
            'expTime': expTime
        }
    )
    return response
    
def getRequestInfo(requestId):
    response = tableRequestData.query(KeyConditionExpression=Key('requestId').eq(requestId))
    return response

def updateRequestInfo(requestId, userId, email, name, grade, subject, times, sessionType, tutorId, taken, confirmed, expTime):
    response = tableRequestData.delete_item(
        Key={
            'requestId': requestId,
        }
    )
    response = tableRequestData.put_item(
        Item={
            'requestId': requestId,
            'userId': userId,
            'email': email,
            'name': name,
            'grade': grade,
            'subject': subject,
            'times': times,
            'sessionType': sessionType,
            'tutorId': tutorId,
            'taken': taken,
            'confirmed': confirmed,
            'expTime': expTime
        }
    )
    return response

def getUserInfo(userId):
    response = tableUserData.query(KeyConditionExpression=Key('userId').eq(userId))
    return response

def getAllRequestInfo():
    response = tableRequestData.scan()
    data = response['Items']
    while 'LastEvaluatedKey' in response:   
        response = tableRequestData.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        data.extend(response['Items'])
    return response

def deleteRequestInfo(requestId):
    response = tableRequestData.delete_item(
        Key={
            'requestId': requestId,
        }
    )
