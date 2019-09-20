//
//  CustomerRequestPriceQuote.swift
//  DoneFast
//
//  Created by Ciber on 9/14/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class CustomerRequestPriceQuote: NSObject
{
  var request_id:String?
  var propertyId:String?
  var propertyTitle:String?
  var propertyLocation:String?
  var service_type:String?
  var service_subtype:String?
  var service_fee:String?
  var dispatch_fee:String?
  var permanent_fee:String?
  var job_id:String?
  var vendro_name:String?
  var job_status:String?
  var priceQuoteStatus:String?
  var requestOn:String?
  
}

class CustomerRequestDetailPriceQuote: NSObject
{
  var request_id:String?
  var propertyId:String?
  var propertyTitle:String?
  var propertyLocation:String?
  var service_type:String?
  var service_subtype:String?
  var service_fee:String?
  var dispatch_fee:String?
  var permanent_fee:String?
  var job_id:String?
  var vendro_name:String?
  var job_status:String?
  var priceQuoteStatus:String?
  var requestOn:String?
  var latLong:String?
  var travelStart_date:String?
  var travelEnd_date:String?
  var workStart_date:String?
  var workEnd_date:String?
  var rateMinute:String?
  var totalWork_hours:String?
  var extraPart_fee:String?
  var total_fee:String?
  var pdf:String?
  var inspectionPdf:String?

}
