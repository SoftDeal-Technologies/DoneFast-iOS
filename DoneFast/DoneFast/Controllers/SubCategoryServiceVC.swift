//
//  SubCategoryServiceVC.swift
//  DoneFast
//
//  Created by Ciber on 9/4/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PopOverType
{
  case PropertyDesign,ServiceSubCategory,EditOrDeleteProperty
}

class SubCategoryServiceVC: UIViewController
{
  var popOverType:PopOverType!
  
  var delegate:ServiceSubCategoryDelegate?
  
  @IBOutlet weak var subCatogaryServiceTableView: UITableView!
//  var serviceListArray:[ServiceSubCatogary] = []
  var serviceListArray:[AnyObject] = []
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.subCatogaryServiceTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
}

extension SubCategoryServiceVC:UITableViewDelegate,UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return serviceListArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cellIdentifier = "CellIdentifier"
    tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let Cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    
    if self.popOverType == PopOverType.ServiceSubCategory
    {
      let serviceSubCategory = serviceListArray[indexPath.row] as? ServiceSubCatogary
      if let serviceName = serviceSubCategory!.name
      {
        Cell.textLabel?.text = serviceName
      }
    }
    else if self.popOverType == PopOverType.PropertyDesign
    {
      let tempReqdict = serviceListArray[indexPath.row]
      if let name = tempReqdict["name"]
      {
        Cell.textLabel?.text = (name as! String)
      }
    }
    else if self.popOverType == PopOverType.EditOrDeleteProperty
    {
      let serviceSubCategory = serviceListArray[indexPath.row]
      Cell.textLabel?.text = (serviceSubCategory as! String)
    }
    return Cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
//    self.dismiss(animated: true, completion:nil)
    self.dismiss(animated: true) {
      if self.popOverType == PopOverType.ServiceSubCategory
      {
        let serviceSubCategory = (self.serviceListArray[indexPath.row] as? ServiceSubCatogary)!
        self.delegate?.selectedSubCategory(selectedSubCategory: serviceSubCategory)
      }
      else if self.popOverType == PopOverType.PropertyDesign
      {
        //      let tempReqdict = serviceListArray[indexPath.row]
        self.delegate?.selectedSubCategory(selectedSubCategory: indexPath.row as AnyObject)
      }
      else if self.popOverType == PopOverType.EditOrDeleteProperty
      {
        self.delegate?.selectedSubCategory(selectedSubCategory: indexPath.row as AnyObject)
      }
    }
  }
}
