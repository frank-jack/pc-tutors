//
//  ModelData.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var profile = Profile.default
    var showApp = false
    var possibleSubjects = ["Math", "Science", "English", "Social Studies", "Spanish", "Latin", "French", "Chinese"]
    var possibleTimes = ["Mon. Before School (7:35-8:05 AM)", "Mon. During Flex (9:25-10:00 AM)", "Mon. After School (2:45-3:15 PM)", "Mon. Early Evening (4:30-5:00 PM)", "Mon. Late Evening (6:00-8:00 PM)", "Tue. Before School (7:35-8:05 AM)", "Tue. During Flex (9:25-10:00 AM)", "Tue. After School (2:45-3:15 PM)", "Tue. Early Evening (4:30-5:00 PM)", "Tue. Late Evening (6:00-8:00 PM)", "Wed. Before School (7:35-8:05 AM)", "Wed. During Flex (9:25-10:00 AM)", "Wed. After School (2:45-3:15 PM)", "Wed. Early Evening (4:30-5:00 PM)", "Wed. Late Evening (6:00-8:00 PM)", "Thur. Before School (7:35-8:05 AM)", "Thur. During Flex (9:25-10:00 AM)", "Thur. After School (2:45-3:15 PM)", "Thur. Early Evening (4:30-5:00 PM)", "Thur. Late Evening (6:00-8:00 PM)", "Fri. Before School (7:35-8:05 AM)", "Fri. During Flex (9:25-10:00 AM)", "Fri. After School (2:45-3:15 PM)", "Fri. Early Evening (4:30-5:00 PM)", "Fri. Late Evening (6:00-8:00 PM)", "Saturday Morning", "Saturday Afternoon", "Sunday Morning", "Sunday Evening"]
    var possibleGrades = [6, 7, 8]
    @Published var refresh = false
    func updateData() {
        let params = ["userId": profile.userId, "email": profile.email, "userType": profile.userType, "name": profile.name, "grade": String(profile.grade), "bio": profile.bio, "subjects": profile.subjects.description, "times": profile.times.description, "requests": profile.requests.description, "connections": profile.connections.description] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/userData")!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    func getRequest(requestId: String) -> Request {
        var request = Request.default
        var getRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/match?"+requestId)!)
        getRequest.httpMethod = "GET"
        getRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let getSession = URLSession.shared
        let getTask = getSession.dataTask(with: getRequest, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print("json start")
                print(json)
                print("json end")
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.userId = items["userId"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.email = items["email"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.name = items["name"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.grade = items["grade"] as! Int
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.subject = items["subject"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.times = items["times"] as! [String]
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.sessionType = items["sessionType"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.tutorId = items["tutorId"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.taken = items["taken"] as! Bool
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.confirmed = items["confirmed"] as! Bool
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    request.expTime = items["expTime"] as! String
                }
                request.requestId = requestId
            } catch {
                print("error")
            }
        })
        getTask.resume()
        while(request.requestId == "") {}
        return request
    }
    func getUpdatedProfile(userId: String) -> Profile {
        var profile = Profile.default
        var getRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/userData?"+userId)!)
        getRequest.httpMethod = "GET"
        getRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let getSession = URLSession.shared
        let getTask = getSession.dataTask(with: getRequest, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print("json start")
                print(json)
                print("json end")
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.email = items["email"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.name = items["name"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.grade = items["grade"] as! Int
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.bio = items["bio"] as! String
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.subjects = items["subjects"] as! [String]
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.times = items["times"] as! [String]
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.requests = items["requests"] as! [String]
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.connections = items["connections"] as! [String]
                }
                if let jsonArray = json["Items"] as? [[String:Any]],
                   let items = jsonArray.first {
                    profile.userType = items["userType"] as! String
                }
                profile.userId = userId
            } catch {
                print("error")
            }
        })
        getTask.resume()
        while(profile.userId == "") {}
        return profile
    }
    func deleteRequest(requestId: String) {
        var deleteRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/match?"+requestId)!)
        deleteRequest.httpMethod = "DELETE"
        deleteRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let deleteSession = URLSession.shared
        let deleteTask = deleteSession.dataTask(with: deleteRequest, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print("json start")
                print(json)
                print("json end")
            } catch {
                print("error")
            }
        })
        deleteTask.resume()
    }
}
