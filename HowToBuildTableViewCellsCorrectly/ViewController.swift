//
//  ViewController.swift
//  HowToBuildTableViewCellsCorrectly
//
//  Created by Eric Dockery on 6/1/18.
//  Copyright © 2018 Eric Dockery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var isEnabled = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var cellData: [CustomCellDataSource] {
        return [CustomCellDataSource(true), CustomCellDataSource(isEnabled), CustomCellDataSource(isEnabled), CustomCellDataSource(isEnabled),
                CustomCellDataSource(isEnabled)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: CustomCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CustomCell.reuseID)

        NetworkCoordinator.shared.fetchRecentPhotos { (sucess) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.isEnabled = !self.isEnabled
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isEnabled = !isEnabled
        self.tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CustomCell else { return }
        let thisCellsData = cellData[indexPath.row]
        cell.isUserInteractionEnabled = thisCellsData.isBlocked
    }


}

