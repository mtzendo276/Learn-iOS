//
//  RepoTableViewController.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import UIKit

class RepoTableViewController: UITableViewController {

    private let viewModel = RepoTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMostPopularRepos(language: "Swift") { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? RepoTableViewCell else {
            return UITableViewCell()
        }

        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        cell.viewModel = cellViewModel

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionationViewController = segue.destination as? UserViewController,
            let selectionIndexPath = tableView.indexPathForSelectedRow {
            let userLogin = viewModel.selectedUserLogin(index: selectionIndexPath.row)
            destionationViewController.userLogin = userLogin
        }
    }
}
