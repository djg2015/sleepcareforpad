//
//  PartInfoList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/11/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation

class PartInfoList:BaseMessage{

    var partinfoList:Array<PartInfo> = Array<PartInfo>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = PartInfoList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var partInfos = doc.nodesForXPath("//PartInfo", error:nil) as! [DDXMLElement]
        for partInfo in partInfos {
            var tempPartInfo = PartInfo()
            
            if(partInfo.elementForName("MainCode") != nil)
            {
                tempPartInfo.MainCode = partInfo.elementForName("MainCode").stringValue()
            }
            
            if(partInfo.elementForName("PartCode") != nil)
            {
                tempPartInfo.PartCode = partInfo.elementForName("PartCode").stringValue()
            }
            if(partInfo.elementForName("PartName") != nil)
            {
                tempPartInfo.PartName = partInfo.elementForName("PartName").stringValue()
            }
            if(partInfo.elementForName("Location") != nil)
            {
                tempPartInfo.Location = partInfo.elementForName("Location").stringValue()
            }
            if(partInfo.elementForName("RoomCount") != nil)
            {
                tempPartInfo.RoomCount = partInfo.elementForName("RoomCount").stringValue()
            }
            if(partInfo.elementForName("BedCount") != nil)
            {
                tempPartInfo.BedCount = partInfo.elementForName("BedCount").stringValue()
            }
            if(partInfo.elementForName("BindingCount") != nil)
            {
                tempPartInfo.BindingCount = partInfo.elementForName("BindingCount").stringValue()
            }
            //获取role节点的子节点
            let beds = partInfo.nodesForXPath("//Bed", error:nil) as! [DDXMLElement]
            for bed in beds {
                var newBed = Bed()
                if(bed.elementForName("BedCode") != nil)
                {
                    newBed.BedCode = bed.elementForName("BedCode").stringValue()
                }
                if(bed.elementForName("BedNumber") != nil)
                {
                    newBed.BedNumber = bed.elementForName("BedNumber").stringValue()
                }
                if(bed.elementForName("RoomCode") != nil)
                {
                    newBed.RoomCode = bed.elementForName("RoomCode").stringValue()
                }
                if(bed.elementForName("RoomNumber") != nil)
                {
                    newBed.RoomNumber = bed.elementForName("RoomNumber").stringValue()
                }
                if(bed.elementForName("UserCode") != nil)
                {
                    newBed.UserCode = bed.elementForName("UserCode").stringValue()
                }
                if(bed.elementForName("UserName") != nil)
                {
                    newBed.UserName = bed.elementForName("UserName").stringValue()
                }
                if(bed.elementForName("CaseCode") != nil)
                {
                    newBed.CaseCode = bed.elementForName("CaseCode").stringValue()
                }
                if(bed.elementForName("OnBedStatus") != nil)
                {
                    newBed.OnBedStatus = bed.elementForName("OnBedStatus").stringValue()
                }
                if(bed.elementForName("Sleep") != nil)
                {
                    newBed.Sleep = bed.elementForName("Sleep").stringValue()
                }
                tempPartInfo.BedList.append(newBed)
            }
            result.partinfoList.append(tempPartInfo)
        }
        return result
    }

}