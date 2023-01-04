//
//  RepoTableViewCell.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    public static let reuseIdentifier = "RepoCellID"

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!

    public var viewModel: RepoTableViewCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            repoNameLabel.text = viewModel.name
            descriptionLabel.text = viewModel.desc
            languageNameLabel.text = viewModel.language
            starCountLabel.text = viewModel.starsCount
        }
    }

}
