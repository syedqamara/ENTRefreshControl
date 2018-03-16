//
//  ViewController.swift
//  ENTRefreshControl
//
//  Created by etDev24 on 03/15/2018.
//  Copyright (c) 2018 etDev24. All rights reserved.
//

import UIKit
import ENTRefreshControl
class ViewController: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    let refControl = ENTRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refControl.loaderView = loadingView
        tableView.addSubview(refControl)
        refControl.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func refreshing() {
        label.text = "Started Refreshing"
    }
    
    @IBAction func didStopRefresh() {
        label.text = "Stoped Refreshing"
        refControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

