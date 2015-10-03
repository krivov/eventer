//
//  FacebookConstants.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

extension FacebookClient {
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
