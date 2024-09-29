//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var languageLabel: UILabel!

    @IBOutlet weak var stargazersLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!

    var repository: Repository?

    override func viewDidLoad() {
        super.viewDidLoad()

        setLabels()
        fetchAvatarImage()
    }
    
    private func setLabels() {
        titleLabel.text = repository?.fullName ?? "unknown"
        if let language = repository?.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = "No language information"
        }
        stargazersLabel.text = "\(repository?.stargazersCount ?? 0) stars"
        watchersLabel.text = "\(repository?.watchersCount ?? 0) watchers"
        forksLabel.text = "\(repository?.forksCount ?? 0) forks"
        issuesLabel.text = "\(repository?.openIssuesCount ?? 0) open issues"
    }

    private func fetchAvatarImage() {
        if let owner = repository?.owner {
            let imgUrl = owner.avatarUrl
            
            Task {
                do {
                    avatarImageView.image = try await URLSessionAPI.fetchImage(imgUrl: imgUrl)
                } catch {
                    print(error)
                }
            }
        }
    }
}
