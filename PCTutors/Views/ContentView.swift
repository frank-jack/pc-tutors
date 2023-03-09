//
//  ContentView.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var sessionManager = SessionManager()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    @State private var selection: Tab = .requests
    enum Tab {
        case requests
        case connections
    }
    @State private var email = ""
    @State private var userType = "New"
    @State private var name = ""
    @State private var grade = -1
    @State private var bio = ""
    @State private var subjects: [String] = []
    @State private var times: [String] = []
    @State private var requests: [String] = []
    @State private var connections: [String] = []
    @State private var showSettings = false
    @State private var showSetup = false
    @State private var showTemp = true
    var body: some View {
        NavigationView {
            if modelData.showApp {
                ZStack {
                    if #available(iOS 16.0, *) {
                        NavigationLink(destination: Temp(), isActive: $showTemp) {}
                    }
                    Color("Background").ignoresSafeArea(.all)
                    VStack {
                        if modelData.profile.userType == "New" {
                            Text("Are You a\nStudent or a Tutor?")
                                .font(.largeTitle)
                                .bold()
                                .multilineTextAlignment(.center)
                            HStack {
                                Button("Student") {
                                    modelData.profile.userType = "Student"
                                    modelData.profile.subjects = []
                                    modelData.profile.times = []
                                    modelData.updateData()
                                    showSetup = true
                                }
                                Button("Tutor") {
                                    modelData.profile.userType = "Tutor"
                                    modelData.profile.grade = -1
                                    modelData.updateData()
                                    showSetup = true
                                }
                            }
                        } else {
                            if !showSetup {
                                VStack {
                                    TabView(selection: $selection) {
                                        Requests()
                                            .tabItem {
                                                Label("Requests", systemImage: "chart.bar.fill")
                                            }
                                            .tag(Tab.requests)
                                        Connections()
                                            .tabItem {
                                                Label("Connections", systemImage: "list.bullet")
                                            }
                                            .tag(Tab.connections)
                                    }
                                }
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button {
                                            showSettings.toggle()
                                        } label: {
                                            Label("Settings", systemImage: "gear")
                                        }
                                    }
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button {
                                            modelData.refresh = true
                                        } label: {
                                            Label("Refresh", systemImage: "arrow.clockwise")
                                        }
                                    }
                                }
                                .sheet(isPresented: $showSettings) {
                                    Settings()
                                        .environmentObject(sessionManager)
                                }
                            } else {
                                NavigationLink(destination: Setup(), isActive: $showSetup) {}
                            }
                        }
                    }
                }
            } else {
                ZStack {
                    Color("Background").ignoresSafeArea(.all)
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        switch sessionManager.authState {
                            case .logIn:
                                LogIn()
                                    .environmentObject(sessionManager)
                            case .signUp:
                                SignUp()
                                    .environmentObject(sessionManager)
                            case .confirmCode(let email):
                                Confirmation(email: email)
                                    .environmentObject(sessionManager)
                            case .session(let user):
                                Session(user: user)
                                    .environmentObject(sessionManager)
                                    .onAppear() {
                                        modelData.showApp = true
                                        print("EMAIL: "+sessionManager.email)
                                        if Amplify.Auth.getCurrentUser()!.userId != "dd14240c-1966-44bb-a8ec-16de01f7d5b2" {
                                            var getRequest = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/userData?"+Amplify.Auth.getCurrentUser()!.userId)!)
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
                                                        email = items["email"] as! String
                                                        print(email)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        name = items["name"] as! String
                                                        print(name)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        grade = items["grade"] as! Int
                                                        print(String(grade))
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        bio = items["bio"] as! String
                                                        print(bio)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        subjects = items["subjects"] as! [String]
                                                        print(subjects)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        times = items["times"] as! [String]
                                                        print(times)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        requests = items["requests"] as! [String]
                                                        print(requests)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        connections = items["connections"] as! [String]
                                                        print(connections)
                                                    }
                                                    if let jsonArray = json["Items"] as? [[String:Any]],
                                                       let items = jsonArray.first {
                                                        userType = items["userType"] as! String
                                                        print(userType)
                                                    } else {
                                                        let params = ["userId": Amplify.Auth.getCurrentUser()!.userId, "email": sessionManager.email, "userType": "New", "name": "", "grade": "-1", "bio": "", "subjects": "[]", "times": "[]", "requests": "[]", "connections": "[]"] as! Dictionary<String, String>
                                                        var request = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/userData")!)
                                                        request.httpMethod = "POST"
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
                                                    if email.count == 0 {
                                                        email = sessionManager.email
                                                    }
                                                    modelData.profile = Profile(email: email, userId: Amplify.Auth.getCurrentUser()?.userId ?? "error", userType: userType, name: name, grade: grade, bio: bio, subjects: subjects, times: times, requests: requests, connections: connections)
                                                } catch {
                                                    print("error")
                                                }
                                            })
                                            getTask.resume()
                                        } else {
                                            print("GUEST")
                                            modelData.profile = Profile(email: "support@pc-tutors.com", userId: "1", userType: "Student", name: "", grade: -1, bio: "", subjects: [], times: [], requests: [], connections: [])
                                            showSetup = true
                                        }
                                    }
                            case .reset:
                                Reset()
                                    .environmentObject(sessionManager)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private func configureAmplify() {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
        print("Amplify configured successfully")
        
    } catch {
        print("could not initialize Amplify", error)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
