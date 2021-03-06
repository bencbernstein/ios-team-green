//
//  SearchTableViewController.swift
//  MakeUp App
//
//  Created by amit chadha on 4/10/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var productArray = [Product]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navBar(title: "Search Results", leftButton: .backToSearch, rightButton: nil)
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: "myProductCell")
        
        let searchString = UserStore.sharedInstance.searchQuery
        ProductAPIClient().stringSearch(searchString: searchString, offset: -5) { (products) in
            DispatchQueue.main.async {
                self.productArray = products
                self.tableView.reloadData()
            }
        }
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            print("calling another query")
            ProductAPIClient().stringSearch(searchString: UserStore.sharedInstance.searchQuery, offset: 15) { (products) in
                DispatchQueue.main.async {
                    products.forEach {
                        self.productArray.append($0)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProductCell", for: indexPath) as! ProductCell
        cell.product = productArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productArray[indexPath.row]
        FirebaseManager.shared.addProductToDatabase(product)
        ResultStore.sharedInstance.product = product
        NotificationCenter.default.post(name: .productVC, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
}
