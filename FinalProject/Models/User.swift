//
//  User.swift
//  FinalProject
//
//  Created by salha asyri on 15/05/1443 AH.
//

import Foundation
import UIKit

struct User: Decodable{
    var id: String
    var firstName: String
    var lastName: String
    var picture: String?
    var phone: String?
    var email: String?
    var gender: String?
    var location: Location?
}
