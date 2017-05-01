//
//  ViewController.swift
//  FoodbankApp
//
//  Created by Tim Windsor Brown on 01/05/2017.
//  Copyright © 2017 Tim Windsor Brown. All rights reserved.
//

import UIKit

class FoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    
    var foodItems:[FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
    }
    
    func loadData() {
        
        APIManager.loadAllDataForFoodbank(foodbankID: 50) { (items:[FoodItem]?, errors:APIManager.ErrorType?) in
            
            if let items = items {
                self.foodItems = items
                self.tableView.reloadData()
            }
        }
    }

    func itemForIndexPath(indexPath:IndexPath) -> FoodItem? {
        
        switch indexPath.section {
        case 0:
            return self.foodItems.filter({ $0.status == FoodItem.Status.high })[indexPath.row]
            
        case 1:
            return self.foodItems.filter({ $0.status == FoodItem.Status.medium })[indexPath.row]
            
        case 2:
            return self.foodItems.filter({ $0.status == FoodItem.Status.low })[indexPath.row]
            
        default:
            return nil
        }
    }
    
    
    // MARK: - TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        
        case 0:
            return "Urgently needed"
            
        case 1:
            return "Low on stock"
            
        case 2:
            return "Well stocked"
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.foodItems.filter({ $0.status == FoodItem.Status.high }).count
            
        case 1:
            return self.foodItems.filter({ $0.status == FoodItem.Status.medium }).count
            
        case 2:
            return self.foodItems.filter({ $0.status == FoodItem.Status.low }).count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "FoodItemCell") as? FoodItemCell,
            let foodItem = self.itemForIndexPath(indexPath: indexPath) {
            
            cell.cellTitle.text = "\(foodItem.name)"
            
            switch foodItem.status {
            case .high:
                cell.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            case .medium:
                cell.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
            case .low:
                cell.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    

}

class FoodItemCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
}

