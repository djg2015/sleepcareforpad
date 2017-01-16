//
//  SinglePartInfo.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/11/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation

class SinglePartInfo:BaseMessage{
    var BedList = Array<Bed>()
    var MainCode:String = ""
    var PartCode:String = ""
    var PartName:String = ""
    var Location:String = ""
    var RoomCount:String = ""
    var BedCount:String = ""
    var BindingCount:String = ""
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = SinglePartInfo(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var partInfos = doc.nodesForXPath("//PartInfo", error:nil) as! [DDXMLElement]
        for partInfo in partInfos {
           
            
            if(partInfo.elementForName("MainCode") != nil)
            {
                result.MainCode = partInfo.elementForName("MainCode").stringValue()
            }
            
            if(partInfo.elementForName("PartCode") != nil)
            {
                result.PartCode = partInfo.elementForName("PartCode").stringValue()
            }
            if(partInfo.elementForName("PartName") != nil)
            {
                result.PartName = partInfo.elementForName("PartName").stringValue()
            }
            if(partInfo.elementForName("Location") != nil)
            {
                result.Location = partInfo.elementForName("Location").stringValue()
            }
            if(partInfo.elementForName("RoomCount") != nil)
            {
                result.RoomCount = partInfo.elementForName("RoomCount").stringValue()
            }
            if(partInfo.elementForName("BedCount") != nil)
            {
               result.BedCount = partInfo.elementForName("BedCount").stringValue()
            }
            if(partInfo.elementForName("BindingCount") != nil)
            {
               result.BindingCount = partInfo.elementForName("BindingCount").stringValue()
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
                if(bed.elementForName("EquipmentID") != nil)
                {
                    newBed.EquipmentID = bed.elementForName("EquipmentID").stringValue()
                }
                
               result.BedList.append(newBed)
            }
        }
        return result
    }

    
}