//
//  Request.swift
//  PCTutors
//
//  Created by Jack Frank on 8/23/22.
//

import Foundation

struct Request: Hashable {
    var requestId: String
    var userId: String
    var email: String
    var name: String
    var grade: Int
    var subject: String
    var times: [String]
    var sessionType: String
    var tutorId: String
    var taken: Bool
    var confirmed: Bool
    var expTime: String
    
    static let `default` = Request(requestId: "", userId: "", email: "", name: "", grade: -1, subject: "", times: [], sessionType: "", tutorId: "", taken: false, confirmed: false, expTime: "")
}
