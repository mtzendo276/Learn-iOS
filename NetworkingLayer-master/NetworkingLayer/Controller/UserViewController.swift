//
//  UserViewController.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 06/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    private let viewModel = UserViewModel()

    public var userLogin: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let login = userLogin else { return }
        viewModel.user(login: login) { [weak self] in
            if let url = self?.viewModel.imageURL {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                } catch _ { }
            }
            DispatchQueue.main.async {
                self?.nameLabel.text = self?.viewModel.name
                self?.loginLabel.text = self?.viewModel.username
                self?.bioLabel.text = self?.viewModel.bio
            }
        }
    }

}
