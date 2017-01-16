//
//  UserBasicInfo.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/6/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation
class UserBasicInfo:BaseMessage{

    var UserCode:String = ""
    var UserName:String = ""
    var Age:String = ""
    var Sex:String = ""
    var Phone:String = ""
    var Address:String = ""
    var CaseCode:String = ""
    
   
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = UserBasicInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var users = doc.nodesForXPath("//UserBasicInfo", error:nil) as! [DDXMLElement]
        for user in users {
            if(user.elementForName("UserCode") != nil)
            {
                result.UserCode = user.elementForName("UserCode").stringValue()
            }
            if(user.elementForName("UserName") != nil)
            {
                result.UserName = user.elementForName("UserName").stringValue()
            }
            if(user.elementForName("Age") != nil)
            {
                result.Age = user.elementForName("Age").stringValue()
            }
            if(user.elementForName("Sex") != nil)
            {
                result.Sex = user.elementForName("Sex").stringValue()
            }
            if(user.elementForName("Phone") != nil)
            {
                result.Phone = user.elementForName("Phone").stringValue()
            }
            if(user.elementForName("Address") != nil)
            {
                result.Address = user.elementForName("Address").stringValue()
            }
            if(user.elementForName("CaseCode") != nil)
            {
                result.CaseCode = user.elementForName("CaseCode").stringValue()
            }
        }
        return result
    }
    
}