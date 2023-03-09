//
//  Settings.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI
import Amplify

struct Settings: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    @State private var showSetup = false
    @State private var showSwitch = false
    @State private var showDelete = false
    @State private var text = "Delete Account"
    @State var confirm = ""
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            VStack {
                if !showDelete {
                    if !showSetup {
                        VStack {
                            Text(modelData.profile.name)
                                .font(.largeTitle)
                                .bold()
                            Text(modelData.profile.userType)
                        }
                        Button("Account Details") {
                            showSetup = true
                        }
                        Spacer()
                        if !showSwitch {
                            Button("Not a "+modelData.profile.userType+"?") {
                                showSwitch = true
                            }
                        } else {
                            Button("This may delete aspects of your account.\nAre you sure you are not a "+modelData.profile.userType+"?") {
                                modelData.profile.userType = "New"
                                modelData.updateData()
                                showSwitch = false
                            }
                        }
                        Text(.init("[Visit Our Website](http://pc-tutors.com/)"))
                        Text(.init("[More Resources](https://docs.google.com/document/d/1HL6mN-Lz7V-XXMxDgE5vL9Fv2CCdXVrQTlrcHePvT7s/edit)"))
                        Button("Sign Out") {
                            sessionManager.signOut()
                            modelData.showApp = false
                        }
                        if modelData.profile.email != "support@pc-tutors.com" {
                            Button("Delete Account") {
                                showDelete = true
                            }
                            .foregroundColor(.red)
                        }
                    } else {
                        NavigationView {
                            NavigationLink(destination: Setup(), isActive: $showSetup) {}
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                } else {
                    Text("Delete Account")
                        .font(.largeTitle)
                        .bold()
                    TextField("Type 'CONFIRM'", text: $confirm)
                        .multilineTextAlignment(.center)
                    Button(text) {
                        confirm = String(confirm.filter { !" \n\t\r".contains($0) })
                        if confirm == "CONFIRM" {
                            print("Ready to Delete")
                            if text == "Delete Account" {
                                text = "Are you sure?"
                            } else {
                                print("deleting")
                                Amplify.Auth.deleteUser()
                                presentationMode.wrappedValue.dismiss()
                                sessionManager.signOut()
                                modelData.showApp = false
                            }
                        }
                    }
                    .foregroundColor(.red)
                    Button("Cancel") {
                        showDelete = false
                        confirm = ""
                        text = "Delete Account"
                    }
                }
            }
            .padding()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
