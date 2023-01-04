//
//  RepoTableViewCellModel.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

class RepoTableViewCellModel {

    private let repo: Repo

    init(repo: Repo) {
        self.repo = repo
    }

    var name: String {
        return repo.name
    }

    var ownerName: String {
        return repo.owner.login
    }

    var desc: String {
        return repo.description
    }

    var starsCount: String {
        return "\(repo.stargazers_count)"
    }

    var language: String {
        return repo.language
    }
}
