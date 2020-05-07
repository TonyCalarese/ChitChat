//
//  Message.swift
//  ChitChat_Calarese
//
//  Created by Tony Calarese on 4/29/20.
//  Copyright © 2020 Tony Calarese. All rights reserved.
//

import Foundation

//Structure used for parsing JSON contents
struct MESSAGE: Decodable {
                     var _id: String
                     var client: String
                     var date: String
                     var message: String
                     var ip: String
                     var likes: Int
                     var dislikes: Int
                     var loc: [String?]
                 }
