//
//  RequestTutoring.swift
//  PCTutors
//
//  Created by Jack Frank on 8/19/22.
//

import SwiftUI

struct RequestTutoring: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    @State private var subject = ""
    @State private var times = [String]()
    @State private var virtual = false
    @State private var inPerson = false
    @State private var sessionType = ""
    @State private var text = ""
    @State private var guestEmail = ""
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            VStack {
                Text("Tutoring Request")
                    .font(.largeTitle)
                    .bold()
                if #available(iOS 16.0, *) {
                    Form {
                        if modelData.profile.email == "support@pc-tutors.com" {
                            Section(header: Text("Email")) {
                                TextField("Email", text: $guestEmail)
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        Section(header: Text("Choose Session Type")) {
                            HStack {
                                Toggle(isOn: $virtual, label: {
                                    Text("Virtual")
                                })
                                .toggleStyle(CheckboxStyle())
                                Toggle(isOn: $inPerson, label: {
                                    Text("In Person")
                                })
                                .toggleStyle(CheckboxStyle())
                            }
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("Choose A Subject")) {
                            NavigationLink(destination: {
                                SingleSelectPickerView(allItems: modelData.possibleSubjects, selectedItem: $subject)
                                    .navigationTitle("Choose A Subject")
                            }, label: {
                                if subject == "" {
                                    Text("Select Subject:")
                                } else {
                                    Text(subject)
                                }
                            })
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("Choose Avaliable Times:")){
                            NavigationLink(destination: {
                                MultiSelectPickerView(allItems: modelData.possibleTimes, selectedItems: $times)
                                    .navigationTitle("Choose Avaliable Times")
                            }, label: {
                                HStack {
                                    Text("Select Times:")
                                    Spacer()
                                    Image(systemName: "\($times.count).circle")
                                        .font(.title2)
                                }
                            })
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("My Selected Times Are:")) {
                            Text(times.joined(separator: "\n"))
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                    }
                    .background(Color("Background"))
                    .scrollContentBackground(.hidden)
                } else {
                    Form {
                        if modelData.profile.email == "support@pc-tutors.com" {
                            Section(header: Text("Email")) {
                                TextField("Email", text: $guestEmail)
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        Section(header: Text("Choose Session Type")) {
                            HStack {
                                Toggle(isOn: $virtual, label: {
                                    Text("Virtual")
                                })
                                .toggleStyle(CheckboxStyle())
                                Toggle(isOn: $inPerson, label: {
                                    Text("In Person")
                                })
                                .toggleStyle(CheckboxStyle())
                            }
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("Choose A Subject")) {
                            NavigationLink(destination: {
                                SingleSelectPickerView(allItems: modelData.possibleSubjects, selectedItem: $subject)
                                    .navigationTitle("Choose A Subject")
                            }, label: {
                                if subject == "" {
                                    Text("Select Subject:")
                                } else {
                                    Text(subject)
                                }
                            })
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("Choose Avaliable Times:")){
                            NavigationLink(destination: {
                                MultiSelectPickerView(allItems: modelData.possibleTimes, selectedItems: $times)
                                    .navigationTitle("Choose Avaliable Times")
                            }, label: {
                                HStack {
                                    Text("Select Times:")
                                    Spacer()
                                    Image(systemName: "\($times.count).circle")
                                        .font(.title2)
                                }
                            })
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        Section(header: Text("My Selected Times Are:")) {
                            Text(times.joined(separator: "\n"))
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                    }
                }
                Text(text)
                Button("Submit Request") {
                    if virtual && inPerson {
                        sessionType = "Either Virtual or In Person"
                    } else if virtual {
                        sessionType = "Virtual"
                    } else if inPerson {
                        sessionType = "In Person"
                    }
                    if sessionType == "" || subject == "" || times.count == 0 || (guestEmail == "" && modelData.profile.email == "support@pc-tutors.com") {
                        text = "Fill Out All Fields"
                    } else {
                        if guestEmail != "" {
                            modelData.profile.email = guestEmail
                        }
                        let requestId = UUID().uuidString
                        let params = ["userId": modelData.profile.userId, "email": modelData.profile.email,  "name": modelData.profile.name, "grade": String(modelData.profile.grade), "subject": subject, "times": times.description, "sessionType": sessionType, "requestId": requestId] as! Dictionary<String, String>
                        var request = URLRequest(url: URL(string: "https://nhuyiydk6h.execute-api.us-east-1.amazonaws.com/dev/match")!)
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
                        if guestEmail != "" {
                            modelData.profile.email = "support@pc-tutors.com"
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    struct CheckboxStyle: ToggleStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            return HStack {
                configuration.label
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? Color("Background") : .gray)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
            }
        }
    }
}

struct RequestTutoring_Previews: PreviewProvider {
    static var previews: some View {
        RequestTutoring()
    }
}
