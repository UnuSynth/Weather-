//
//  ViewController.swift
//  WeatherApp
//
//  Created by Amantay on 25/01/2020.
//  Copyright © 2020 Amantay. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        searchBar.delegate = self;
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder();
        
        
    }
}
