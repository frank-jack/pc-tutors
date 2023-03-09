//
//  Setup.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI

struct Setup: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var bio = ""
    @State private var grade = -1
    @State private var subjects = [String]()
    @State private var times = [String]()
    @State private var firstTime = true
    @State private var text = ""
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            VStack {
                Text("Account Details")
                    .font(.largeTitle)
                    .bold()
                if #available(iOS 16.0, *) {
                    Form {
                        Section(header: Text("Name")) {
                            TextEditor(text: $name)
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        if modelData.profile.userType == "Tutor" {
                            Section(header: Text("Write A Small Bio About Yourself")) {
                                TextEditor(text: $bio)
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        if modelData.profile.userType == "Student" {
                            Section(header: Text("Choose Your Grade")) {
                                NavigationLink(destination: {
                                    SingleSelectPickerViewInt(allItems: modelData.possibleGrades, selectedItem: $grade)
                                        .navigationTitle("Choose Your Grade")
                                }, label: {
                                    if grade == -1 {
                                        Text("Select Grade:")
                                    } else {
                                        Text(String(grade))
                                    }
                                })
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        if modelData.profile.userType == "Tutor" {
                            Section(header: Text("Choose Your Subjects")) {
                                NavigationLink(destination: {
                                    MultiSelectPickerView(allItems: modelData.possibleSubjects, selectedItems: $subjects)
                                        .navigationTitle("Choose Your Subjects")
                                }, label: {
                                    HStack {
                                        Text("Select Subjects:")
                                        Spacer()
                                        Image(systemName: "\($subjects.count).circle")
                                            .font(.title2)
                                    }
                                })
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                            Section(header: Text("My Selected Subjects Are:")) {
                                Text(subjects.joined(separator: "\n"))
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                            Section(header: Text("Choose Available Times")) {
                                NavigationLink(destination: {
                                    MultiSelectPickerView(allItems: modelData.possibleTimes, selectedItems: $times)
                                        .navigationTitle("Choose Available Times")
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
                    .background(Color("Background"))
                    .scrollContentBackground(.hidden)
                } else {
                    Form {
                        Section(header: Text("Name")) {
                            TextEditor(text: $name)
                        }
                        .listRowBackground(Color.blue.opacity(0.4))
                        if modelData.profile.userType == "Tutor" {
                            Section(header: Text("Write A Small Bio")) {
                                TextEditor(text: $bio)
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        if modelData.profile.userType == "Student" {
                            Section(header: Text("Choose Your Grade")) {
                                NavigationLink(destination: {
                                    SingleSelectPickerViewInt(allItems: modelData.possibleGrades, selectedItem: $grade)
                                        .navigationTitle("Choose Your Grade")
                                }, label: {
                                    if grade == -1 {
                                        Text("Select Grade:")
                                    } else {
                                        Text(String(grade))
                                    }
                                })
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                        }
                        if modelData.profile.userType == "Tutor" {
                            Section(header: Text("Choose Your Subjects")) {
                                NavigationLink(destination: {
                                    MultiSelectPickerView(allItems: modelData.possibleSubjects, selectedItems: $subjects)
                                        .navigationTitle("Choose Your Subjects")
                                }, label: {
                                    HStack {
                                        Text("Select Subjects:")
                                        Spacer()
                                        Image(systemName: "\($subjects.count).circle")
                                            .font(.title2)
                                    }
                                })
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                            Section(header: Text("My Selected Subjects Are:")) {
                                Text(subjects.joined(separator: "\n"))
                            }
                            .listRowBackground(Color.blue.opacity(0.4))
                            Section(header: Text("Choose Available Times")) {
                                NavigationLink(destination: {
                                    MultiSelectPickerView(allItems: modelData.possibleTimes, selectedItems: $times)
                                        .navigationTitle("Choose Available Times")
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
                }
                Text(text)
                    .multilineTextAlignment(.center)
                Button("Submit") {
                    if !(modelData.profile.userType == "Student" && grade < 1) && !(modelData.profile.userType == "Tutor" && subjects.count == 0) && !(modelData.profile.userType == "Tutor" && times.count == 0) && name.count != 0 && !(modelData.profile.userType == "Tutor" && bio.count == 0) {
                        modelData.profile.name = name
                        modelData.profile.bio = bio
                        modelData.profile.grade = grade
                        modelData.profile.subjects = subjects
                        modelData.profile.times = times
                        modelData.updateData()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        text = "Fill Out All Fields"
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                text = ""
                if firstTime {
                    name = modelData.profile.name
                    bio = modelData.profile.bio
                    grade = modelData.profile.grade
                    subjects = modelData.profile.subjects
                    times = modelData.profile.times
                    firstTime = false
                }
            }
        }
    }
}

struct Setup_Previews: PreviewProvider {
    static var previews: some View {
        Setup()
    }
}
