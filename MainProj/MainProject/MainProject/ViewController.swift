//
//  ViewController.swift
//  MainProject
//
//  Created by JunHo Park on 2023/02/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    private let vcList : [(vc: UIViewController.Type, name: String)] = [
        (UIHostingController<SwiftUIExampleRootView>.self, "SwiftUIExampl View Controller")
    ]
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewInit()
    }
    
    private func viewInit() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        self.tableView.reloadData()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = vcList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuple = vcList[indexPath.row]
        var vc: UIViewController?
        let str = String(describing: tuple.vc)
        if tuple.vc == UIHostingController<SwiftUIExampleRootView>.self {
            let swiftUIRoot = UIHostingController(rootView: SwiftUIExampleRootView(navigationController: self.navigationController))
            // swiftUIRoot.modalPresentationStyle = .fullScreen
            // self.present(swiftUIRoot, animated: true)
            self.navigationController?.pushViewController(viewController: swiftUIRoot, animated: true, completion: {
                
            })
            return
        }
        guard let vc = vc else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
