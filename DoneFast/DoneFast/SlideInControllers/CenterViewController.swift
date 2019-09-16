//
//  CenterViewController.swift
//  DoneFast
//
//  Created by Ciber on 9/15/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.didSelectRow(selectedRow: 0)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol CenterViewControllerDelegate
{
  func toggleLeftPanel()
  func collapseSidePanels()
}

extension CenterViewController: SidePanelViewControllerDelegate
{
  func didSelectRow(selectedRow: Int)
  {
    switch selectedRow {
    case 0:
      guard let customerListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerPropertyListVC") as? CustomerPropertyListVC
        else
      {
        return
      }
      customerListVC.delegate = self.delegate
      self.navigationController!.pushViewController(customerListVC, animated: false)
    case 2:
      guard let customerAddPropertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerAddPropertyVC") as? CustomerAddPropertyVC
        else
      {
        return
      }
//      customerAddPropertyVC.delegate = self.delegate
      self.navigationController!.pushViewController(customerAddPropertyVC, animated: false)
    case 1:
      guard let customerJobHistoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerJobHistoryVC") as? CustomerJobHistoryVC
        else
      {
        return
      }
      customerJobHistoryVC.delegate = self.delegate
      self.navigationController!.pushViewController(customerJobHistoryVC, animated: false)
    case 4:
      guard let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
        else
      {
        return
      }
      self.navigationController!.pushViewController(userProfileVC, animated: false)
    default:
      print("\(selectedRow)")
    }
    delegate?.collapseSidePanels()
  }
}
