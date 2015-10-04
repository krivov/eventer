//
//  FacebookConstants.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit
import Foundation

extension FacebookClient {
    
    struct Constants {
        static let CoondinatesDelta = 0.5
    }
    
    struct JSONRequestParams {
        static let Since = "now"
        static let Until = "next year"
        static let Limit = 1000
        static let TypeEvent = "event"
        static let Fields = "id,attending_count,declined_count,description,end_time,latitude,longitude,maybe_count,name,noreply_count,owner,place,start_time,ticket_uri,cover"
    }
    
    struct JSONResponseKeys {
        static let Result = "result"
        static let Message = "message"
    }
    
    //MARK: - JSON Response Values
    
    struct JSONResponseValues {
        
        static let Fail = "fail"
        static let Ok = "ok"
    }
}
