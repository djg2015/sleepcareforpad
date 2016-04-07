//
//  Result.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/3.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class Result: BaseMessage {
   var ReturnResult:Bool = false
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = Result(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var result1 = doc.rootElement() as DDXMLElement!
        result.ReturnResult = result1.elementForName("IsSuccessful").stringValue() == "true" ? true : false
        
        return result
    }
}