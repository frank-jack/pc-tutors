//
//  SignUp.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI

struct SignUp: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var password = ""
    @State var email = ""
    @State private var tempText = ""
    var body: some View {
        VStack {
            Spacer()
            TextField("Email", text: $email)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
            Text(tempText)
            Button("Sign Up") {
                if password.count < 8 {
                    tempText = "Password must be at least 8 characters"
                } else {
                    if email.contains("@penncharter.com") {
                        sessionManager.signUp(username: email, email: email, password: password)
                    } else {
                        tempText = "Use your Penn Charter email to sign up"
                    }
                }
            }
            Spacer()
            Button("Already have an account? Log in.", action: sessionManager.showLogIn)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
