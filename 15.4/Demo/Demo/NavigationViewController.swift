//
//  NavigationViewController.swift
//  Demo
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
//        setNavigationBarHidden(true, animated: false)
    }
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    } 
}


extension NavigationController: UINavigationControllerDelegate {
    
}


extension UIViewController {
    @objc func backBarButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func closeBarButtonItemClicked() {
        dismiss(animated: true, completion: nil)
    }
}

