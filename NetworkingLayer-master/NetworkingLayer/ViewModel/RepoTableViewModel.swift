//
//  RepoTableViewModel.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

class RepoTableViewModel {

    private let networking = Networking()

    private var repos: Repos?

    public func getMostPopularRepos(language: String,
                             completion: (() -> Void)?) {
        networking.performNetworkTask(endpoint: GitHubAPI.repositories(language: language),
                                      type: Repos.self) { [weak self] (response) in
                                        self?.repos = response
                                        completion?()
        }
    }

    public func cellViewModel(index: Int) -> RepoTableViewCellModel? {
        guard let repos = repos else { return nil }
        let repoTableViewCellModel = RepoTableViewCellModel(repo: repos.items[index])
        return repoTableViewCellModel
    }
    
    public var count: Int {
        return repos?.items.count ?? 0
    }

    public func selectedUserLogin(index: Int) -> String {
        return repos?.items[index].owner.login ?? ""
    }
}
