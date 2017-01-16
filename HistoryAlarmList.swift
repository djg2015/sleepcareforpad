//
//  HistoryAlarmList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/11/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation
class HistoryAlarmList:BaseMessage{

var alarmItemList = Array<HistoryAlarmItem>()
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = HistoryAlarmList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var alarmItems = doc.nodesForXPath("//AlarmItem", error:nil) as! [DDXMLElement]
        for alarmItem in alarmItems {
            var newalarmItem = HistoryAlarmItem()
            
            if(nil != alarmItem.elementForName("AlarmCode"))
            {
                newalarmItem.AlarmCode = alarmItem.elementForName("AlarmCode").stringValue()
            }
            
            if(nil != alarmItem.elementForName("AlarmTime"))
            {
                newalarmItem.AlarmTime = alarmItem.elementForName("AlarmTime").stringValue()
            }
            if(nil != alarmItem.elementForName("AlarmType"))
            {
                newalarmItem.AlarmType = alarmItem.elementForName("AlarmType").stringValue()
            }
            if(nil != alarmItem.elementForName("Content"))
            {
                newalarmItem.Content = alarmItem.elementForName("Content").stringValue()
            }
            if(nil != alarmItem.elementForName("HandleStatus"))
            {
                newalarmItem.HandleStatus = alarmItem.elementForName("HandleStatus").stringValue()
            }
            if(nil != alarmItem.elementForName("HandleTime"))
            {
                newalarmItem.HandleTime = alarmItem.elementForName("HandleTime").stringValue()
            }
            
                   result.alarmItemList.append(newalarmItem)
        }
        return result
    }

}