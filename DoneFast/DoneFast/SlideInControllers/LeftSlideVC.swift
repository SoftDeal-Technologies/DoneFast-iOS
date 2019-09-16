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
  @IBOutlet weak var customerNameLabel: UILabel!
  @IBOutlet weak var customerEmailLabel: UILabel!
  @IBOutlet weak var customerProfileImageView: UIImageView!
  
  var delegate: SidePanelViewControllerDelegate?

  override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//      customerNameButton.setTitle(UserLoginDetails.shared.userName, for: .normal)
//      customerEmailButton.setTitle(UserLoginDetails.shared.userEmail, for: .normal)
      customerNameLabel.text = UserLoginDetails.shared.userName
      customerEmailLabel.text = UserLoginDetails.shared.userEmail
      customerProfileImageView.layer.cornerRadius = (customerProfileImageView.frame.size.width/2)
      if let profileImageUrl = UserLoginDetails.shared.userProfileImage
      {
//        self.downloadImage(from: URL(string: profileImageUrl)!)
        self.customerProfileImageView.downloaded(from: URL(string: profileImageUrl)!)
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
    delegate?.didSelectRow(selectedRow: 4) // 0 to 3 for tabular data
//    guard let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
//      else
//    {
//      return
//    }
//    self.navigationController!.pushViewController(userProfileVC, animated: false)
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
    delegate?.didSelectRow(selectedRow: indexPath.row) // 4 for user profile
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


extension UIImageView
{
  func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
      DispatchQueue.main.async() {
        self.image = image
      }
      }.resume()
  }
  func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill)
  {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
    guard let url = URL(string: link) else { return }
    downloaded(from: url, contentMode: mode)
  }
}

protocol SidePanelViewControllerDelegate
{
  func didSelectRow(selectedRow: Int)
}
