//
//  BusinessFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class BusinessFactory<T>{
    class func GetBusinessInstance(name:String) -> T{
       
        
        return SleepCareBussiness() as! T
    }
}