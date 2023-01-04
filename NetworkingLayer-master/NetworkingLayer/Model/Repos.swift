//
//  Repos.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 06/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

struct Repos: Codable {
    let total_count: Int
    let items: [Repo]
}
