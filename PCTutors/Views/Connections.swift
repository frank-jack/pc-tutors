//
//  Connections.swift
//  PCTutors
//
//  Created by Jack Frank on 8/24/22.
//

import SwiftUI

struct Connections: View {
    @EnvironmentObject var modelData: ModelData
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    @State private var connections: [Request] = []
    @State private var showDeleteAlert = false
    @State private var showCheckAlert = false
    @State private var showConfAlert = false
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            VStack {
                if modelData.profile.userType == "Tutor" {
                    Text("Tutoring Connections")
                        .font(.largeTitle)
                        .bold()
                    if #available(iOS 16.0, *) {
                        if connections.count != 0 {
                            List {
                                ForEach(connections, id: \.self) { connection in
                                    Section(header: HStack {
                                        Text(connection.name)
                                        Spacer()
                                        if connection.confirmed {
                                            Label("", systemImage: "checkmark.circle.fill")
                                        } else {
                                            Button {
                                                showCheckAlert = true
                                            } label: {
                                                Label("", systemImage: "exclamationmark.circle")
                                                    .foregroundColor(.red)
                                            }
                                            .alert(isPresented: $showCheckAlert) {
                                                Alert(
                                                    title: Text("This Tutoring Connection Is Not Yet Confirmed"),
                                                    dismissButton: .default(Text("Done"))
                                                )
                                            }
                                        }
                                        Button {
                                            showDeleteAlert = true
                                        } label: {
                                            Label("", systemImage: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        .alert(isPresented: $showDeleteAlert) {
                                            Alert(
                                                title: Text("Delete Connection?"),
                                                primaryButton: .default(Text("Cancel"), action: {
                                                    showDeleteAlert = false
                                                }),
                                                secondaryButton: .destructive(Text("Delete"), action: {
                                                    modelData.deleteRequest(requestId: connection.requestId)
                                                    modelData.profile.connections.remove(at: modelData.profile.connections.firstIndex(of: connection.requestId)!)
                                                    modelData.profile.requests.remove(at: modelData.profile.requests.firstIndex(of: connection.requestId)!)
                                                    connections = []
                                                    for i in modelData.profile.connections {
                                                        connections.append(modelData.getRequest(requestId: i))
                                                    }
                                                    print(connections)
                                                })
                                            )
                                        }
                                    }) {
                                        Text(connection.email)
                                        Text("Grade: "+String(connection.grade))
                                        Text("Subject: "+connection.subject)
                                        Text("Available Times: "+connection.times.joined(separator: ", "))
                                        Text("Session Type: "+connection.sessionType)
                                    }
                                    .listRowBackground(Color.blue.opacity(0.4))
                                    .headerProminence(.increased)
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
                            ForEach(connections, id: \.self) { connection in
                                Section(header: HStack {
                                    Text(connection.name)
                                    Spacer()
                                    if connection.confirmed {
                                        Label("", systemImage: "checkmark.circle.fill")
                                    } else {
                                        Button {
                                            showCheckAlert = true
                                        } label: {
                                            Label("", systemImage: "exclamationmark.circle")
                                                .foregroundColor(.red)
                                        }
                                        .alert(isPresented: $showCheckAlert) {
                                            Alert(
                                                title: Text("This Tutoring Connection Is Not Yet Confirmed"),
                                                dismissButton: .default(Text("Done"))
                                            )
                                        }
                                    }
                                    Button {
                                        showDeleteAlert = true
                                    } label: {
                                        Label("", systemImage: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .alert(isPresented: $showDeleteAlert) {
                                        Alert(
                                            title: Text("Delete Connection?"),
                                            primaryButton: .default(Text("Cancel"), action: {
                                                showDeleteAlert = false
                                            }),
                                            secondaryButton: .destructive(Text("Delete"), action: {
                                                modelData.deleteRequest(requestId: connection.requestId)
                                                modelData.profile.connections.remove(at: modelData.profile.connections.firstIndex(of: connection.requestId)!)
                                                modelData.profile.requests.remove(at: modelData.profile.requests.firstIndex(of: connection.requestId)!)
                                                connections = []
                                                for i in modelData.profile.connections {
                                                    connections.append(modelData.getRequest(requestId: i))
                                                }
                                                print(connections)
                                            })
                                        )
                                    }
                                }) {
                                    Text(connection.email)
                                    Text("Grade: "+String(connection.grade))
                                    Text("Subject: "+connection.subject)
                                    Text("Available Times: "+connection.times.joined(separator: ", "))
                                    Text("Session Type: "+connection.sessionType)
                                }
                                .listRowBackground(Color.blue.opacity(0.4))
                                .headerProminence(.increased)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                } else if modelData.profile.userType == "Student" {
                    Text("Tutoring Connections")
                        .font(.largeTitle)
                        .bold()
                    if #available(iOS 16.0, *) {
                        if connections.count != 0 {
                            List {
                                ForEach(connections, id: \.self) { connection in
                                    Section(header: HStack {
                                        Text(modelData.getUpdatedProfile(userId: connection.tutorId).name)
                                        Spacer()
                                        if modelData.getRequest(requestId: connection.requestId).confirmed {
                                            Label("", systemImage: "checkmark.circle.fill")
                                        } else {
                                            Button {
                                                showConfAlert = true
                                            } label: {
                                                Label("", systemImage: "exclamationmark.circle")
                                                    .foregroundColor(.red)
                                            }
                                            .alert(isPresented: $showConfAlert) {
                                                Alert(
                                                    title: Text("Confirm This Tutoring Connection?"),
                                                    primaryButton: .default(Text("Cancel"), action: {
                                                        showConfAlert = false
                                                    }),
                                                    secondaryButton: .default(Text("OK"), action: {
                                                        let params = ["userId": connection.userId, "email": connection.email,  "name": connection.name, "grade": String(connection.grade), "subject": connection.subject, "times": connection.times.description, "sessionType": connection.sessionType, "requestId": connection.requestId, "tutorId": connection.tutorId, "taken": "true", "confirmed": "true", "expTime": connection.expTime] as! Dictionary<String, String>
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
                                                        connections = []
                                                        for i in modelData.profile.connections {
                                                            connections.append(modelData.getRequest(requestId: i))
                                                        }
                                                        print(connections)
                                                    })
                                                )
                                            }
                                        }
                                        Button {
                                            showDeleteAlert = true
                                        } label: {
                                            Label("", systemImage: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        .alert(isPresented: $showDeleteAlert) {
                                            Alert(
                                                title: Text("Delete Connection?"),
                                                primaryButton: .default(Text("Cancel"), action: {
                                                    showDeleteAlert = false
                                                }),
                                                secondaryButton: .destructive(Text("Delete"), action: {
                                                    modelData.deleteRequest(requestId: connection.requestId)
                                                    modelData.profile.connections.remove(at: modelData.profile.connections.firstIndex(of: connection.requestId)!)
                                                    modelData.profile.requests.remove(at: modelData.profile.requests.firstIndex(of: connection.requestId)!)
                                                    connections = []
                                                    for i in modelData.profile.connections {
                                                        connections.append(modelData.getRequest(requestId: i))
                                                    }
                                                    print(connections)
                                                })
                                            )
                                        }
                                    }) {
                                        Text("Tutor Email: "+modelData.getUpdatedProfile(userId: connection.tutorId).email)
                                        Text("Tutor Bio: "+modelData.getUpdatedProfile(userId: connection.tutorId).bio)
                                        Text("Subject: "+connection.subject)
                                        Text("Available Times: "+connection.times.joined(separator: ", "))
                                        Text("Session Type: "+connection.sessionType)
                                    }
                                    .listRowBackground(Color.blue.opacity(0.4))
                                    .headerProminence(.increased)
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
                            ForEach(connections, id: \.self) { connection in
                                Section(header: HStack {
                                    Text(modelData.getUpdatedProfile(userId: connection.tutorId).name)
                                    Spacer()
                                    if modelData.getRequest(requestId: connection.requestId).confirmed {
                                        Label("", systemImage: "checkmark.circle.fill")
                                    } else {
                                        Button {
                                            showConfAlert = true
                                        } label: {
                                            Label("", systemImage: "exclamationmark.circle")
                                                .foregroundColor(.red)
                                        }
                                        .alert(isPresented: $showConfAlert) {
                                            Alert(
                                                title: Text("Confirm This Tutoring Connection?"),
                                                primaryButton: .default(Text("Cancel"), action: {
                                                    showConfAlert = false
                                                }),
                                                secondaryButton: .default(Text("OK"), action: {
                                                    let params = ["userId": connection.userId, "email": connection.email,  "name": connection.name, "grade": String(connection.grade), "subject": connection.subject, "times": connection.times.description, "sessionType": connection.sessionType, "requestId": connection.requestId, "tutorId": connection.tutorId, "taken": "true", "confirmed": "true", "expTime": connection.expTime] as! Dictionary<String, String>
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
                                                    connections = []
                                                    for i in modelData.profile.connections {
                                                        connections.append(modelData.getRequest(requestId: i))
                                                    }
                                                    print(connections)
                                                })
                                            )
                                        }
                                    }
                                    Button {
                                        showDeleteAlert = true
                                    } label: {
                                        Label("", systemImage: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .alert(isPresented: $showDeleteAlert) {
                                        Alert(
                                            title: Text("Delete Connection?"),
                                            primaryButton: .default(Text("Cancel"), action: {
                                                showDeleteAlert = false
                                            }),
                                            secondaryButton: .destructive(Text("Delete"), action: {
                                                modelData.deleteRequest(requestId: connection.requestId)
                                                modelData.profile.connections.remove(at: modelData.profile.connections.firstIndex(of: connection.requestId)!)
                                                modelData.profile.requests.remove(at: modelData.profile.requests.firstIndex(of: connection.requestId)!)
                                                connections = []
                                                for i in modelData.profile.connections {
                                                    connections.append(modelData.getRequest(requestId: i))
                                                }
                                                print(connections)
                                            })
                                        )
                                    }
                                }) {
                                    Text("Tutor Email: "+modelData.getUpdatedProfile(userId: connection.tutorId).email)
                                    Text("Tutor Bio: "+modelData.getUpdatedProfile(userId: connection.tutorId).bio)
                                    Text("Subject: "+connection.subject)
                                    Text("Available Times: "+connection.times.joined(separator: ", "))
                                    Text("Session Type: "+connection.sessionType)
                                }
                                .listRowBackground(Color.blue.opacity(0.4))
                                .headerProminence(.increased)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .onAppear() {
                connections = []
                for i in modelData.profile.connections {
                    connections.append(modelData.getRequest(requestId: i))
                }
                print(connections)
            }
            .onChange(of: modelData.refresh) { newValue in
                print("Refresh")
                modelData.profile = modelData.getUpdatedProfile(userId: modelData.profile.userId)
                connections = []
                for i in modelData.profile.connections {
                    connections.append(modelData.getRequest(requestId: i))
                }
                print(connections)
                modelData.refresh = false
            }
        }
    }
}

struct Connections_Previews: PreviewProvider {
    static var previews: some View {
        Connections()
    }
}
