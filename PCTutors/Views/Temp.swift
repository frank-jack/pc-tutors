//
//  Temp.swift
//  PCTutors
//
//  Created by Jack Frank on 11/9/22.
//

import SwiftUI

struct Temp: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Color("Background").ignoresSafeArea(.all)
            .onAppear {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct Temp_Previews: PreviewProvider {
    static var previews: some View {
        Temp()
    }
}
