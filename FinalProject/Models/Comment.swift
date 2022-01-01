//
//  Comment.swift
//  FinalProject
//
//  Created by salha asyri on 15/05/1443 AH.
//

import Foundation
struct Comment: Decodable{
    var id: String
    var message:String
    var owner: User
}
