//
//  GitHubAPI.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

enum GitHubAPI {
    case repositories(language: String)
    case user(login: String)
}

extension GitHubAPI: EndpointType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .repositories(let language):
            return "/search/repositories?q=+language:\(language)&sort=stars&order=desc"
        case .user(let login):
            return "/users/\(login)"
        }
    }
}
