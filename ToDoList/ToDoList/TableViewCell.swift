//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Ram Yadav on 8/16/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit



class TableViewCell: UITableViewController {
   static var list = ["Apple", "Mango", "Orange"]
    override func viewDidLoad() {
        super .viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCell.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = TableViewCell.list[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
          TableViewCell.list.remove(at: indexPath.row)
          tableView.reloadData()
        }
    }
    

    @IBAction func addItemToList(_ sender: Any) {
        let tableView = TableViewCell()
        let viewController = ViewController()
        tableView.addChildViewController(viewController)
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
}

