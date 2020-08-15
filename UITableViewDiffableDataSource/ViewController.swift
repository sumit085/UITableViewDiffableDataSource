//
//  ViewController.swift
//  UITableViewDiffableDataSource
//
//  Created by Admin on 01/08/20.
//  Copyright © 2020 UITableViewDiffableDataSource. All rights reserved.
//

import UIKit
enum SECTION{
    case first
}
struct USER : Hashable {
    let name : String
}

typealias tableViewDataSource = UITableViewDiffableDataSource<SECTION, USER>
typealias snapshot = NSDiffableDataSourceSnapshot<SECTION, USER>

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var userData = [USER]()
    var dataSource : tableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    func configureDataSource(){
        dataSource = tableViewDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.name
            return cell
        })
    }
    
    @IBAction func tapOnAdd(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Add User", preferredStyle: .alert)
        
       let Okay = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        if let text = alert?.textFields?.first?.text{
            self.addUser(name : text)
        }
        })
        alert.addTextField { (textField) in
            textField.placeholder = "Enter UserName"
        }
        alert.addAction(Okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addUser(name : String){
        userData.append(USER(name: name))
        createSnapShot(users: userData)
    }
    
    func createSnapShot(users: [USER]){
      var snap = snapshot()
        snap.appendSections([.first])
        snap.appendItems(users)
        dataSource.apply(snap, animatingDifferences: true)
    }
}
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dataSource.itemIdentifier(for: indexPath)?.name)
    }
}
