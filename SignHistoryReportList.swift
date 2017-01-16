//
//  SignHistoryReportList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/6/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation

class SignHistoryReportList:BaseMessage{

var signHistoryReportList = Array<SignHistoryReport>()
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = SignHistoryReportList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var historyReports = doc.nodesForXPath("//SignHistoryReport", error:nil) as! [DDXMLElement]
        for historyReport in historyReports {
            var newHistoryReport = SignHistoryReport()
            newHistoryReport.CaseNumber = historyReport.elementForName("CaseNumber").stringValue()
            newHistoryReport.BedNumber = historyReport.elementForName("BedNumber").stringValue()
            newHistoryReport.UserName = historyReport.elementForName("UserName").stringValue()
            if(nil != historyReport.elementForName("AnalysisTimespan"))
            {
                newHistoryReport.AnalysisTimespan = historyReport.elementForName("AnalysisTimespan").stringValue()
            }
            if(nil != historyReport.elementForName("AvgHR"))
            {
                newHistoryReport.AvgHR = historyReport.elementForName("AvgHR").stringValue()
            }
            if(nil != historyReport.elementForName("AvgRR"))
            {
                newHistoryReport.AvgRR = historyReport.elementForName("AvgRR").stringValue()
            }
            if(nil != historyReport.elementForName("TurnTimes"))
            {
                newHistoryReport.TurnTimes = historyReport.elementForName("TurnTimes").stringValue()
            }
           
        
            result.signHistoryReportList.append(newHistoryReport)
        }
        return result
    }


}