//
//  Profile.swift
//  PCTutors
//
//  Created by Jack Frank on 8/18/22.
//

import Foundation
import SwiftUI

struct Profile {
    var email: String
    var userId: String
    var userType: String
    var name: String
    var grade: Int
    var bio: String
    var subjects: [String]
    var times: [String]
    var requests: [String]
    var connections: [String]

    static let `default` = Profile(email: "", userId: "", userType: "New", name: "", grade: -1, bio: "", subjects: [], times: [], requests: [], connections: [])
}
