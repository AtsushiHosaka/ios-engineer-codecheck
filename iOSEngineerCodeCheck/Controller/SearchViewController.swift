//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var repositoryList: [Repository] = []

    var networkTask: URLSessionTask?

    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchBar()
        setupActivityIndicator()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        
        if let searchTextField = searchBar.value(forKey: "searchTextField") as? UITextField {
            searchTextField.font = UIFont(name: "Futura-Medium", size: 16)
        }
        
        // MARK: Test
        searchBar.accessibilityTraits = .searchField
        searchBar.accessibilityIdentifier = "searchBar"
        searchBar.isAccessibilityElement = true
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }

    // 画面遷移時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueDestination.detail.rawValue {
            guard let selectedRepositoryIndex = sender as? Int else {
                print("error: sender is nil")
                return
            }
            
            guard let detailViewController = segue.destination as? DetailViewController else {
                print("error: cannot cast segue.destination as? DetailViewController")
                return
            }
            
            detailViewController.repository = self.repositoryList[selectedRepositoryIndex]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryList.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let repository = repositoryList[indexPath.row]
        
        var content = createCellConfig(for: cell, repository: repository)

        if let avatarImage = repository.owner.image {
            content.image = avatarImage
        } else {
            content.image = UIImage(systemName: "person.circle")
            fetchAvatarImage(for: repository, at: indexPath)
        }
        
        cell.contentConfiguration = content
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let repository = repositoryList[indexPath.row]
        
        let content = createCellConfig(for: cell, repository: repository)
        
        cell.contentConfiguration = content
        cell.tag = indexPath.row

        return cell
    }
    
    private func createCellConfig(for cell: UITableViewCell, repository: Repository) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        
        content.text = repository.fullName
        content.secondaryText = repository.language

        content.textProperties.font = UIFont(name: "Futura-Medium", size: 17) ?? .systemFont(ofSize: 17)
        content.secondaryTextProperties.font = UIFont(name: "Futura-Medium", size: 13) ?? .systemFont(ofSize: 13)
        
        content.textProperties.color = UIColor.label
        content.secondaryTextProperties.color = UIColor.label

        content.image = UIImage(systemName: "person.circle")
        
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 20
        
        return content
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: SegueDestination.detail.rawValue, sender: indexPath.row)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    private func fetchAvatarImage(for repository: Repository, at indexPath: IndexPath) {
        if let owner = repository.owner as RepositoryOwner? {
            let imgUrl = owner.avatarUrl
            
            Task {
                do {
                    let image = try await URLSessionAPI.fetchImage(imgUrl: imgUrl)
                    
                    repositoryList[indexPath.row].owner.image = image
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    enum SegueDestination: String {
        case detail = "Detail"
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkTask?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else {
            print("error: cannot get searchbar text")
            return
        }

        if searchWord.count != 0 {
            searchBar.resignFirstResponder()

            activityIndicator.startAnimating()
            
            Task {
                do {
                    repositoryList = try await GithubAPI.fetchRepositories(searchWord: searchWord)
                    tableView.reloadData()
                } catch {
                    print(error)
                }

                activityIndicator.stopAnimating()
            }
        }
    }
}
