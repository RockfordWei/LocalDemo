//
//  ViewController.swift
//  LocalDemo
//
//  Created by Rockford Wei on 2022-04-02.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    let cellId = UUID().uuidString
    @objc func onClick(_ sender: Any) {
        let record = Record.random()
        _ = record.insert()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.title = "Demo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onClick))
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let xell = tableView.dequeueReusableCell(withIdentifier: cellId) {
            cell = xell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        let record = Record.records[indexPath.row]
        cell.textLabel?.text = record.title
        cell.detailTextLabel?.text = record.description
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Record.records.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = Record.records[indexPath.row]
            _ = record.delete()
            tableView.reloadData()
        }
    }
}
