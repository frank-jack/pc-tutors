//
//  MultiSelectPickerView.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import SwiftUI

struct MultiSelectPickerView: View {
    @State var allItems: [String]
    @Binding var selectedItems: [String]
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(.all)
            if #available(iOS 16.0, *) {
                Form {
                    List {
                        ForEach(allItems, id: \.self) { item in
                            Button(action: {
                                withAnimation {
                                    if self.selectedItems.contains(item) {
                                        self.selectedItems.removeAll(where: { $0 == item })
                                    } else {
                                        self.selectedItems.append(item)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "checkmark")
                                        .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                                    Text(item)
                                }
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
                                withAnimation {
                                    if self.selectedItems.contains(item) {
                                        self.selectedItems.removeAll(where: { $0 == item })
                                    } else {
                                        self.selectedItems.append(item)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "checkmark")
                                        .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                                    Text(item)
                                }
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
