//
//  ViewController.swift
//  Demo
//
//  Created by liyang on TODAYS_DATE.
//

import UIKit

fileprivate let ReuseID = "TestCaseCell"
fileprivate class TestCaseCell: UITableViewCell {
}

fileprivate enum TestCase: String, CaseIterable {
    case click = "click me"
    
    func perform(from vc: ViewController) {
        switch self {
        case .click:
            print("click")
        }
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBody()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private unowned var tableView: UITableView!
    private lazy var items: [TestCase] = TestCase.allCases
}
  
// MARK: - Delegate
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID, for: indexPath) as! TestCaseCell
        cell.textLabel?.text = String(format: "%02d. ", indexPath.row) + items[indexPath.row].rawValue
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].perform(from: self)
    }
}

// MARK: - Create Views
extension ViewController {
    
    private func setupBody() {
        navigationItem.title = "Debug"
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 45
        tableView.register(TestCaseCell.self, forCellReuseIdentifier: ReuseID)
        view.addSubview(tableView)
        self.tableView = tableView
    }
}

