//
//  WebServices.swift
//  CabelasLocationAudit
//
//  Created by Ciber on 1/28/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum WebServiceType {
    case PCMS_LOGIN,NEW_CUSTOMER_REGISTRATION,LIST_CUSTOMER_PROPERTY,PROPERTY_TYPE,ADD_CUSTOMER_PROPERTY,VIEW_CUSTOMER_PROPERTY, DELETE_CUSTOMER_PROPERTY, UPDATE_CUSTOMER_PROPERTY,JOB_REQUEST,SERVICE_SUB_CATEGORY,CUSTOMER_PROFILE,CUSTOMER_UPDATE_PROFILE,CUSTOMER_REQUESTS,VIEW_PRICE_QUOTE,EDIT_CUSTOMER_PROPERTY,PRICE_REQUEST
}
enum MethodType {
    case GET,POST,PUT
}
class WebServices {
    
  static let sharedWebServices = WebServices()
  
  //Initializer access level change now
  private init(){}

  weak var delegate: WebServiceDelegate?

  var webServiceUrl = "http://rmisys.com/projects/globehome-app/ApiServices/"//ShareDataClass.shared.commonServiceUrl
  
  // Hit Web Service Request
  
  func uploadusingUrlSessionNormalDataWithImage(webServiceParameters:[String: Any]!,methodType:MethodType, webServiceType:WebServiceType, token:String, imagesString:[String],imageDataArray:[UIImage])  {
    // the image in UIImage type
    //    let image = signatureImage
    //
        let filename = "image.png"
    
    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // Set the URLRequest to POST and to the specified URL
    let urlString = webServiceUrl + self.getWebServiceDetails(webServiceType: webServiceType)
    var urlRequest = URLRequest(url: URL(string: urlString)!)
    urlRequest.httpMethod = "POST"
    
    // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
    // And the boundary is also set here
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var data = Data()
    
    // Add the reqtype field and its value to the raw http request data
    
    for (key, value) in webServiceParameters
    {
      data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
      data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
      data.append("\(value)".data(using: .utf8)!)
    }
    
    if webServiceType != .NEW_CUSTOMER_REGISTRATION
    {
      urlRequest.setValue("\(token)", forHTTPHeaderField: "x-authorization")
    }
    
//     Add the image data to the raw http request data
    
    for var i in (0..<imageDataArray.count)
    {
      let dataImage = imageDataArray[i]
      let imageName = imagesString[i]
      data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
      data.append("Content-Disposition: form-data; name=\"\(imageName))\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!) //image1 , customerSignature
      data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
      data.append(dataImage.pngData()!)
      i = i+1
    }

    
    
    // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
    // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    // Send a POST request to the URL, with the data we created earlier
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
      
      if(error != nil)
      {
        print("\(error!.localizedDescription)")
        self.delegate?.failerResponse(responseData: data, webServiceType: webServiceType)
      }
      
      guard let responseData = responseData else {
        print("no response data")
        self.delegate?.failerResponse(responseData: data, webServiceType: webServiceType)
        return
      }
      
      if let responseString = String(data: responseData, encoding: .utf8) {
        print("uploaded to: \(responseString)")
        self.delegate?.successResponse(responseString: responseString, webServiceType: webServiceType)
      }
    }).resume()
  }
  
  
  func uploadusingUrlSessionNormalData(webServiceParameters:[String: Any]!,methodType:MethodType, webServiceType:WebServiceType, token:String)
  {
    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // Set the URLRequest to POST and to the specified URL
    let urlString = webServiceUrl + self.getWebServiceDetails(webServiceType: webServiceType)
    var urlRequest = URLRequest(url: URL(string: urlString)!)
    
    let httpMethod = self.getWebServiceMethod(webServiceMethodType: methodType)
    print(httpMethod.rawValue)
    urlRequest.httpMethod = httpMethod.rawValue
    
    // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
    // And the boundary is also set here
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    if webServiceType != .PCMS_LOGIN || webServiceType != .NEW_CUSTOMER_REGISTRATION
    {
      urlRequest.setValue("\(token)", forHTTPHeaderField: "x-authorization")
    }
    
    var data = Data()
    
    // Add the reqtype field and its value to the raw http request data
    
    for (key, value) in webServiceParameters
    {
      data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
      data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
      data.append("\(value)".data(using: .utf8)!)
    }
    
    // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
    // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    // Send a POST request to the URL, with the data we created earlier
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
      
      if(error != nil)
      {
        print("\(error!.localizedDescription)")
        self.delegate?.failerResponse(responseData: data, webServiceType: webServiceType)
      }
      
      guard let responseData = responseData else {
        print("no response data")
        self.delegate?.failerResponse(responseData: data, webServiceType: webServiceType)
        return
      }
      
      if let responseString = String(data: responseData, encoding: .utf8) {
        print("uploaded to: \(responseString)")
        self.delegate?.successResponse(responseString: responseString, webServiceType: webServiceType)
      }
    }).resume()
  }
  
  // Get Web Service Detailed URL
  func getWebServiceDetails(webServiceType:WebServiceType) -> String {
      var webServiceStr:String!
      switch webServiceType {
      case .PCMS_LOGIN:
          webServiceStr = "Login"
          break
      
      case .NEW_CUSTOMER_REGISTRATION:
            webServiceStr = "CustomerRegistration"
            break
      case .LIST_CUSTOMER_PROPERTY:
        webServiceStr = "ListCustomerProperty"
        break
      case .PROPERTY_TYPE:
        webServiceStr = "propertyType"
        break
      case .ADD_CUSTOMER_PROPERTY:
        webServiceStr = "AddCustomerProperty"
        break
      case .VIEW_CUSTOMER_PROPERTY:
        webServiceStr = "ViewCustomerProperty"
        break
      case .DELETE_CUSTOMER_PROPERTY:
        webServiceStr = "DeleteCustomerProperty"
        break
      case .UPDATE_CUSTOMER_PROPERTY:
        webServiceStr = "EditCustomerProperty"
        break
      case .JOB_REQUEST:
        webServiceStr = "JobRequest"
        break
      case .SERVICE_SUB_CATEGORY:
        webServiceStr = "ServiceSubCategory"
        break
      case .CUSTOMER_PROFILE:
        webServiceStr = "CustomerProfile"
        break
      case .CUSTOMER_UPDATE_PROFILE:
        webServiceStr = "CustomerUpdateProfile"
        break
      case .CUSTOMER_REQUESTS:
        webServiceStr = "CustomerRequests"
        break
      case .VIEW_PRICE_QUOTE:
        webServiceStr = "viewPriceQuote"
        break
      case .EDIT_CUSTOMER_PROPERTY:
        webServiceStr = "EditCustomerProperty"
        break
      case .PRICE_REQUEST:
        webServiceStr = "PriceRequest"
        break
    }
    return webServiceStr
  }

  // Get Web Service Method
  func getWebServiceMethod(webServiceMethodType:MethodType) -> HTTPMethod
  {
      var httpMethod:HTTPMethod!
      switch webServiceMethodType {
      case .POST:
          httpMethod = HTTPMethod.post
          break
      case .PUT:
          httpMethod = HTTPMethod.put
          break
      case .GET:
          httpMethod = HTTPMethod.get
          break
      }
      return httpMethod
  }
}

protocol WebServiceDelegate:AnyObject {

    func successResponse(responseString: String, webServiceType:WebServiceType)
    func failerResponse(responseData: Data, webServiceType:WebServiceType)
}

