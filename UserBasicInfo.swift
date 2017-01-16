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
        var userinfos = doc.nodesForXPath("//UserBasicInfo", error:nil) as! [DDXMLElement]
        for userinfo in userinfos {
            if(userinfo.elementForName("UserCode") != nil)
            {
                result.UserCode = userinfo.elementForName("UserCode").stringValue()
            }
            if(userinfo.elementForName("UserName") != nil)
            {
                result.UserName = userinfo.elementForName("UserName").stringValue()
            }
            if(userinfo.elementForName("Age") != nil)
            {
                result.Age = userinfo.elementForName("Age").stringValue()
            }
            if(userinfo.elementForName("Sex") != nil)
            {
                if(userinfo.elementForName("Sex").stringValue() == "0"){
                result.Sex = "男"
                }
                else if(userinfo.elementForName("Sex").stringValue() == "1"){
                result.Sex = "女"
                }
                
            }
            if(userinfo.elementForName("Phone") != nil)
            {
                result.Phone = userinfo.elementForName("Phone").stringValue()
            }
            if(userinfo.elementForName("Address") != nil)
            {
                result.Address = userinfo.elementForName("Address").stringValue()
            }
            if(userinfo.elementForName("CaseCode") != nil)
            {
                result.CaseCode = userinfo.elementForName("CaseCode").stringValue()
            }
        }
        return result
    }
    
}