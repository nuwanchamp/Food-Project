//
//  FoodDetailViewController.swift
//  FoodProject
//
//  Created by user229897 on 11/19/22.
//

import UIKit

class FoodDetailViewController: UIViewController {

    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
    }
    

}
