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

    var repositoryList: [[String: Any]] = []

    var networkTask: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    // 画面遷移時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let selectedRepositoryIndex = sender as! Int
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.repository = self.repositoryList[selectedRepositoryIndex]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositoryList[indexPath.row]

        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: indexPath.row)
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
        let searchWord = searchBar.text!

        if searchWord.count != 0 {
            let url = "https://api.github.com/search/repositories?q=\(searchWord)"
            networkTask = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
                if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = object["items"] as? [[String: Any]] {
                        self.repositoryList = items
                        DispatchQueue.main.async {
                            // これ呼ばなきゃリストが更新されません
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            networkTask?.resume()
        }
    }
}
