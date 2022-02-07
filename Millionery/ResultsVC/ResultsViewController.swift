//
//  ResultsViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 01.02.2022.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var results = [GameResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.shared.loadResults()
        results = Game.shared.results
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultTableViewCellIdentifire")

    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCellIdentifire", for: indexPath) as? ResultTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configureCell(result: results[indexPath.row])

        return cell
    }



}
