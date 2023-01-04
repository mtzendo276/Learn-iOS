//
//  Repo.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

struct Repo: Codable {
    let name: String
    let description: String
    let owner: User
    let language: String
    let stargazers_count: Int
}
