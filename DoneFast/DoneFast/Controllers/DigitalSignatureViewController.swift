//
//  DigitalSignatureViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/12/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
protocol SignatureDelegate {
  func sendSignatureImage(signatureImage:UIImage)
}
class DigitalSignatureViewController: UIViewController {

  @IBOutlet weak var signatureView: YPDrawSignatureView!
  var delegate:SignatureDelegate?
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }
    
  @IBAction func cancelClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
//    self.performSegue(withIdentifier: "ToCardPaymentView", sender: self)
    
  }
  
  @IBAction func clearClicked(_ sender: Any)
  {
    // This is how the signature gets cleared
    self.signatureView.clear()
  }
  @IBAction func saveClicked(_ sender: Any)
  {
    // Getting the Signature Image from self.drawSignatureView using the method getSignature().
    if let signatureImage = self.signatureView.getSignature(scale: 10)
    {
      
      // Saving signatureImage from the line above to the Photo Roll.
      // The first time you do this, the app asks for access to your pictures.
      
      UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
      
      // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
      self.signatureView.clear()
      self.delegate?.sendSignatureImage(signatureImage: signatureImage)
//        let controller = self.navigationController?.viewControllers
//        print(controller?.count)
      self.navigationController?.popViewController(animated: true)
    }
  }
  func didStart(_ view : YPDrawSignatureView)
  {
      print("Started Drawing")
  }
  func didFinish(_ view : YPDrawSignatureView)
  {
    print("Finished Drawing")
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
