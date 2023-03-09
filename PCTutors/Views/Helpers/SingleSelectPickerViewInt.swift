//
//  SingleSelectPickerViewInt.swift
//  PCTutors
//
//  Created by Jack Frank on 8/27/22.
//

import SwiftUI

struct SingleSelectPickerViewInt: View {
    @Environment(\.presentationMode) var presentationMode
    @State var allItems: [Int]
    @Binding var selectedItem: Int
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            if #available(iOS 16.0, *) {
                Form {
                    List {
                        ForEach(allItems, id: \.self) { item in
                            Button(action: {
                                selectedItem = item
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(String(item))
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .listRowBackground(Color.blue.opacity(0.4))
                }
                .background(Color("Background"))
                .scrollContentBackground(.hidden)
            } else {
                Form {
                    List {
                        ForEach(allItems, id: \.self) { item in
                            Button(action: {
                                selectedItem = item
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(String(item))
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .listRowBackground(Color.blue.opacity(0.4))
                }
            }
        }
    }
}
