//
//  Requests.swift
//  PCTutors
//
//  Created by Jack Frank on 8/24/22.
//

import SwiftUI

struct Requests: View {
    @EnvironmentObject var modelData: ModelData
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    @State private var matchedReqs: [Request] = []
    @State private var takenIds: [String] = []
    @State private var showAlert = false
    @State private var doNotPushToEmpty = false
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            VStack {
                if modelData.profile.userType == "Tutor" {
                    Text("Tutoring Requests")
                        .font(.largeTitle)
                        .bold()
                    if #available(iOS 16.0, *) {
                        if matchedReqs.count != 0 && doNotPushToEmpty {
                            List {
                                ForEach(matchedReqs, id: \.self) { request in
                                    if !modelData.getRequest(requestId: request.requestId).taken {
                                        Section(header: HStack {
                                            Text(request.name)
                                            Spacer()
                                            if modelData.profile.connections.contains(request.requestId) {
                                                Label("", systemImage: "checkmark.circle.fill")
                                            } else {
                                                if takenIds.contains(request.requestId) {
                                                    Label("", systemImage: "x.circle.fill")
                                                } else {
                                                    Button {
                                                        showAlert = true
                                                    } label: {
                                                        Label("", systemImage: "plus.circle")
                                                    }
                                                    .alert(isPresented: $showAlert) {
                                                        Alert(
                                                            title: Text("Connect With This Student?"),
                                                            primaryButton: .default(Text("Cancel"), action: {
                                                                showAlert = false
                                                            }),
                                                            secondaryButton: .default(Text("OK"), action: {
                                                                if !modelData.getRequest(requestId: request.requestId).taken {
                                                                    let params = ["userId": request.userId, "email": request.email,  "name": request.name, "grade": String(request.grade), "subject": request.subject, "times": request.times.description, "sessionType": request.sessionType, "requestId": request.requestId, "tutorId": modelData.profile.userId, "taken": "true", "confirmed": "false", "expTime": request.expTime] as! Dictionary<String, String>
                                                                    var putRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/match")!)
                                                                    putRequest.httpMethod = "PUT"
                                                                    putRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                                                    putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                                                    let session = URLSession.shared
                                                                    let task = session.dataTask(with: putRequest, completionHandler: { data, response, error -> Void in
                                                                        print(response!)
                                                                        do {
                                                                            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                                            print(json)
                                                                        } catch {
                                                                            print("error")
                                                                        }
                                                                    })
                                                                    task.resume()
                                                                    modelData.profile.connections.append(request.requestId)
                                                                }
                                                                takenIds.append(request.requestId)
                                                            })
                                                        )
                                                    }
                                                }
                                            }
                                        }) {
                                            Text(request.email)
                                            Text("Grade: "+String(request.grade))
                                            Text("Subject: "+request.subject)
                                            Text("Available Times: "+request.times.joined(separator: ", "))
                                            Text("Session Type: "+request.sessionType)
                                        }
                                        .listRowBackground(Color.blue.opacity(0.4))
                                        .headerProminence(.increased)
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .background(Color("Background"))
                            .scrollContentBackground(.hidden)
                        } else {
                            List {
                                Text("")
                                    .listRowBackground(Color("Background"))
                            }
                            .background(Color("Background"))
                            .scrollContentBackground(.hidden)
                            .listStyle(.insetGrouped)
                        }
                    } else {
                        List {
                            ForEach(matchedReqs, id: \.self) { request in
                                if !modelData.getRequest(requestId: request.requestId).taken {
                                    Section(header: HStack {
                                        Text(request.name)
                                        Spacer()
                                        if modelData.profile.connections.contains(request.requestId) {
                                            Label("", systemImage: "checkmark.circle.fill")
                                        } else {
                                            if takenIds.contains(request.requestId) {
                                                Label("", systemImage: "x.circle.fill")
                                            } else {
                                                Button {
                                                    showAlert = true
                                                } label: {
                                                    Label("", systemImage: "plus.circle")
                                                }
                                                .alert(isPresented: $showAlert) {
                                                    Alert(
                                                        title: Text("Connect With This Student?"),
                                                        primaryButton: .default(Text("Cancel"), action: {
                                                            showAlert = false
                                                        }),
                                                        secondaryButton: .default(Text("OK"), action: {
                                                            if !modelData.getRequest(requestId: request.requestId).taken {
                                                                let params = ["userId": request.userId, "email": request.email,  "name": request.name, "grade": String(request.grade), "subject": request.subject, "times": request.times.description, "sessionType": request.sessionType, "requestId": request.requestId, "tutorId": modelData.profile.userId, "taken": "true", "confirmed": "false", "expTime": request.expTime] as! Dictionary<String, String>
                                                                var putRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/match")!)
                                                                putRequest.httpMethod = "PUT"
                                                                putRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                                                                putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                                                let session = URLSession.shared
                                                                let task = session.dataTask(with: putRequest, completionHandler: { data, response, error -> Void in
                                                                    print(response!)
                                                                    do {
                                                                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                                        print(json)
                                                                    } catch {
                                                                        print("error")
                                                                    }
                                                                })
                                                                task.resume()
                                                                modelData.profile.connections.append(request.requestId)
                                                            }
                                                            takenIds.append(request.requestId)
                                                        })
                                                    )
                                                }
                                            }
                                        }
                                    }) {
                                        Text(request.email)
                                        Text("Grade: "+String(request.grade))
                                        Text("Subject: "+request.subject)
                                        Text("Available Times: "+request.times.joined(separator: ", "))
                                        Text("Session Type: "+request.sessionType)
                                    }
                                    .listRowBackground(Color.blue.opacity(0.4))
                                    .headerProminence(.increased)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                } else if modelData.profile.userType == "Student" {
                    Text("Pending Requests")
                        .font(.largeTitle)
                        .bold()
                    NavigationLink("Request Tutoring") {
                        RequestTutoring()
                            .onDisappear() {
                                matchedReqs = []
                                for i in modelData.profile.requests {
                                    matchedReqs.append(modelData.getRequest(requestId: i))
                                }
                                print(matchedReqs)
                            }
                    }
                    if #available(iOS 16.0, *) {
                        if matchedReqs.count != 0 && doNotPushToEmpty {
                            List {
                                ForEach(matchedReqs, id: \.self) { request in
                                    if !modelData.getRequest(requestId: request.requestId).taken {
                                        Section(header: Text(request.name)) {
                                            Text(request.email)
                                            Text("Grade: "+String(request.grade))
                                            Text("Subject: "+request.subject)
                                            Text("Available Times: "+request.times.joined(separator: ", "))
                                            Text("Session Type: "+request.sessionType)
                                        }
                                        .listRowBackground(Color.blue.opacity(0.4))
                                        .headerProminence(.increased)
                                    }
                                }
                            }
                            .background(Color("Background"))
                            .scrollContentBackground(.hidden)
                            .listStyle(.insetGrouped)
                        } else {
                            List {
                                Text("")
                                    .listRowBackground(Color("Background"))
                            }
                            .background(Color("Background"))
                            .scrollContentBackground(.hidden)
                            .listStyle(.insetGrouped)
                        }
                    } else {
                        List {
                            ForEach(matchedReqs, id: \.self) { request in
                                if !modelData.getRequest(requestId: request.requestId).taken {
                                    Section(header: Text(request.name)) {
                                        Text(request.email)
                                        Text("Grade: "+String(request.grade))
                                        Text("Subject: "+request.subject)
                                        Text("Available Times: "+request.times.joined(separator: ", "))
                                        Text("Session Type: "+request.sessionType)
                                    }
                                    .listRowBackground(Color.blue.opacity(0.4))
                                    .headerProminence(.increased)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .onAppear() {
                matchedReqs = []
                for i in modelData.profile.requests {
                    matchedReqs.append(modelData.getRequest(requestId: i))
                }
                print(matchedReqs)
                for i in matchedReqs {
                    if !i.taken {
                        doNotPushToEmpty = true
                    }
                }
            }
            .onChange(of: modelData.refresh) { newValue in
                print("Refresh")
                modelData.profile = modelData.getUpdatedProfile(userId: modelData.profile.userId)
                matchedReqs = []
                for i in modelData.profile.requests {
                    matchedReqs.append(modelData.getRequest(requestId: i))
                }
                print(matchedReqs)
                doNotPushToEmpty = false
                for i in matchedReqs {
                    if !i.taken {
                        doNotPushToEmpty = true
                    }
                }
                modelData.refresh = false
            }
        }
    }
}

struct Requests_Previews: PreviewProvider {
    static var previews: some View {
        Requests()
    }
}
