//
//  Confirmation.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI

struct Confirmation: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var confirmationCode = ""
    let email: String
    
    var body: some View {
        VStack {
            Text("Email: \(email)")
            TextField("Confirmation Code sent to your email", text: $confirmationCode)
            Button("Confirm", action: {sessionManager.confirm(username: email, code: confirmationCode)})
            Button("Cancel", action: sessionManager.showLogIn)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct Confirmation_Previews: PreviewProvider {
    static var previews: some View {
        Confirmation(email: "jackfrank1001@gmail.com")
    }
}
