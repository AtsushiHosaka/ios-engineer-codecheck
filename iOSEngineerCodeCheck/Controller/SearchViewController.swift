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
        
        setupSearchBar()
        setupActivityIndicator()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let repository = repositoryList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = repository.fullName
        content.secondaryText = repository.language
        
        cell.contentConfiguration = content
        cell.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: SegueDestination.detail.rawValue, sender: indexPath.row)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
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
