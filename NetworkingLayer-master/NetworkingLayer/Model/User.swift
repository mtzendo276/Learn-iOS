//
//  User.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let url: String
    let name: String?
    let avatar_url: String?
    let bio: String?
}
