//
//  AlarmInfoByQR.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 5/16/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class AlarmInfoByScanQR:BaseMessage{

    var AlarmCode:String = ""
    var UserCode:String = ""
    var UserName:String = ""
    var UserSex:String = ""
    var PartCode:String = ""
    var PartName:String = ""
    var BedCode:String = ""
    var BedNumber:String = ""
    var SchemaCode:String = ""
    var SchemaContent:String = ""
    var AlarmDate:String = ""
    var AlarmTime:String = ""
    //只有坠床报警才有值
    var FoobLevelCode:String = ""
     //只有褥疮风险报警才有值
    var BedSoreLevelCode:String = ""
    //用户护工选择处理结果
    var Templates:Array<String> = Array<String>()
    
    
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = AlarmInfoByScanQR(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var AlarmInfoByQRList = doc.nodesForXPath("//AlarmInfo", error:nil) as! [DDXMLElement]
      
        for tempAlarmInfoByQR in AlarmInfoByQRList{
           result.AlarmCode = tempAlarmInfoByQR.elementForName("AlarmCode").stringValue()
           result.UserCode = tempAlarmInfoByQR.elementForName("UserCode").stringValue()
        result.UserName = tempAlarmInfoByQR.elementForName("UserName").stringValue()
        result.UserSex = tempAlarmInfoByQR.elementForName("UserSex").stringValue()
            result.PartCode = tempAlarmInfoByQR.elementForName("PartCode").stringValue()
        result.PartName = tempAlarmInfoByQR.elementForName("PartName").stringValue()
            result.BedCode = tempAlarmInfoByQR.elementForName("BedCode").stringValue()
            result.BedNumber = tempAlarmInfoByQR.elementForName("BedNumber").stringValue()
        result.SchemaCode = tempAlarmInfoByQR.elementForName("SchemaCode").stringValue()
            result.AlarmTime = tempAlarmInfoByQR.elementForName("AlarmTime").stringValue()
            result.AlarmDate = tempAlarmInfoByQR.elementForName("AlarmDate").stringValue()
            if tempAlarmInfoByQR.elementForName("SchemaContent") != nil{
            result.SchemaContent = tempAlarmInfoByQR.elementForName("SchemaContent").stringValue()
            }
            
            if tempAlarmInfoByQR.elementForName("FoobLevelCode") != nil{
            result.FoobLevelCode = tempAlarmInfoByQR.elementForName("FoobLevelCode").stringValue()
            }
            if tempAlarmInfoByQR.elementForName("BedSoreLevelCode") != nil{
            result.BedSoreLevelCode = tempAlarmInfoByQR.elementForName("BedSoreLevelCode").stringValue()
            }
            
                let TemplateList = doc.nodesForXPath("//Content", error:nil) as! [DDXMLElement]
                for template in TemplateList{
                result.Templates.append(template.stringValue())
                }
        }
        
        return result
    }
}