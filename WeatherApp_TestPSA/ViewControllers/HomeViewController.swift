//
//  HomeViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(presentAddCityView))
    }
    
    @objc func presentAddCityView(){
        guard let addCityVC = storyboard?.instantiateViewController(withIdentifier: AddCityViewController.storyboardIdentifier) as? AddCityViewController else {
            
            print("Impossible de trouver une vue avec cet identifiant \(AddCityViewController.storyboardIdentifier)")

            return
        }
        
        navigationController?.pushViewController(addCityVC, animated: true)
    }
}
