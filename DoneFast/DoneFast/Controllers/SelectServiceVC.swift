//
//  SelectServiceVC.swift
//  DoneFast
//
//  Created by Ciber on 8/22/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class SelectServiceVC: UIViewController {
  
  var delegate: CenterViewControllerDelegate?
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyId:String?
  var selectProperty = 1
  @IBOutlet weak var cleaningBtn: UIButton!
  @IBOutlet weak var handymanBtn: UIButton!
  @IBOutlet weak var homeInspectionBtn: UIButton!
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
   }
  
  // MARK: Button actions
  @IBAction func leftPanelClicked(_ sender: Any)
  {
    delegate?.toggleLeftPanel()
  }
///Users/ciber/Documents/DoneFast/GitCode/DoneFast-iOS/DoneFast/DoneFast/Controllers/SelectServiceVC.swift
  @IBAction func requestServiceClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToRequestDetail", sender: self)
  }
  
  @IBAction func selectServiceClicked(_ sender: Any)
  {
    let senderBtn = sender as? UIButton
    self.selectProperty = senderBtn!.tag
    
    if senderBtn?.tag == 1
    {
      cleaningBtn.backgroundColor = UIColor.blue
      handymanBtn.backgroundColor = UIColor.clear
    }
    else if senderBtn?.tag == 2
    {
      cleaningBtn.backgroundColor = UIColor.clear
      handymanBtn.backgroundColor = UIColor.blue
    }
    else
    {
      
    }
  }
  
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let requestDetailController = segue.destination as? RequestDetailsVC
    requestDetailController?.customerLoginDetails = self.customerLoginDetails
    requestDetailController?.propertyId = self.propertyId
    requestDetailController!.selectedService = self.selectProperty
    requestDetailController?.delegate = self.delegate
  }
  
}

extension SelectServiceVC: SidePanelViewControllerDelegate {
  func didSelectRow(selectedRow: Int) {
  }
}
