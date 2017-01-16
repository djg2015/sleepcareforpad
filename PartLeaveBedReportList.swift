//
//  PartLeaveBedReportList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/6/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation

class PartLeaveBedReportList:BaseMessage{

    var leaveBedReportList = Array<PartLeaveBedReport>()
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        
        let result = PartLeaveBedReportList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var leavebedReports = doc.nodesForXPath("//LeaveBedReport", error:nil) as! [DDXMLElement]
        for leavebedReport in leavebedReports {
            var newLeaveBedReport = PartLeaveBedReport()
            newLeaveBedReport.CaseNumber = leavebedReport.elementForName("CaseNumber").stringValue()
            newLeaveBedReport.BedNumber = leavebedReport.elementForName("BedNumber").stringValue()
            newLeaveBedReport.UserName = leavebedReport.elementForName("UserName").stringValue()
            if(nil != leavebedReport.elementForName("AnalysisTimespan"))
            {
                newLeaveBedReport.AnalysisTimespan = leavebedReport.elementForName("AnalysisTimespan").stringValue()
            }
          
            if(nil != leavebedReport.elementForName("StatusText"))
            {
                newLeaveBedReport.StatusText = leavebedReport.elementForName("StatusText").stringValue()
            }
            
            
            result.leaveBedReportList.append(newLeaveBedReport)
        }
        return result
    }

    
}
