//
//  LeftSlideVC.swift
//  DoneFast
//
//  Created by Ciber on 9/15/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class LeftSlideVC: UIViewController {
  
  @IBOutlet weak var customerListTableView: UITableView!
  @IBOutlet weak var customerNameButton: UIButton!
  @IBOutlet weak var customerEmailButton: UIButton!
  @IBOutlet weak var customerProfileImageView: UIImageView!
  
  var delegate: SidePanelViewControllerDelegate?

  override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      customerNameButton.setTitle(UserLoginDetails.shared.userName, for: .normal)
      customerEmailButton.setTitle(UserLoginDetails.shared.userEmail, for: .normal)
      if let profileImageUrl = UserLoginDetails.shared.userProfileImage
      {
        self.downloadImage(from: URL(string: profileImageUrl)!)
      }
    }
  
    override func viewWillAppear(_ animated: Bool)
    {
      super.viewWillAppear(animated)
    }
  
    func downloadImage(from url: URL)
    {
      print("Download Started")
      getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async()
          {
          self.customerProfileImageView.image = UIImage(data: data)
        }
      }
    }
      
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
  
  @IBAction func viewUserProfileClicked(_ sender: Any)
  {
    
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

extension LeftSlideVC:UITableViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    delegate?.didSelectRow(selectedRow: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension LeftSlideVC:UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
      return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cellIdentifier = "CellIdentifier"
    tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    let tableCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    switch indexPath.row {
    case 0:
      tableCell.textLabel?.text = "Dashboard"
      break
    case 1:
      tableCell.textLabel?.text = "Job History"
      break
    case 2:
      tableCell.textLabel?.text = "Add Property"
      break
    case 3:
      tableCell.textLabel?.text = "LOGOUT"
      break
    default:
      print("")
      break
    }
    return tableCell
  }
}



protocol SidePanelViewControllerDelegate
{
  func didSelectRow(selectedRow: Int)
}
