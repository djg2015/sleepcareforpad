//
//  RoleTreeList.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/31/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

class RoleTreeList:BaseMessage{
    var RoleTrees = Array<RoleTree>()
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = RoleTreeList(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
      
       
        var roleTrees = doc.nodesForXPath("//Role", error:nil) as! [DDXMLElement]
      
        
        for roleTree in roleTrees{
            var newroleTree = RoleTree()
            if(roleTree.elementForName("RoleCode") != nil)
            {
                newroleTree.RoleCode = roleTree.elementForName("RoleCode").stringValue()
            }
            if(roleTree.elementForName("RoleType") != nil)
            {
                newroleTree.RoleType = roleTree.elementForName("RoleType").stringValue()
            }
            if(roleTree.elementForName("ParentCode") != nil)
            {
                newroleTree.ParentCode = roleTree.elementForName("ParentCode").stringValue()
            }
            if(roleTree.elementForName("RoleName") != nil)
            {
                newroleTree.RoleName = roleTree.elementForName("RoleName").stringValue()
            }
            if(roleTree.elementForName("MainCode") != nil)
            {
                newroleTree.MainCode = roleTree.elementForName("MainCode").stringValue()
            }
            if(roleTree.elementForName("MainName") != nil)
            {
                newroleTree.MainName = roleTree.elementForName("MainName").stringValue()
            }
            if(roleTree.elementForName("PartCode") != nil)
            {
                newroleTree.PartCode = roleTree.elementForName("PartCode").stringValue()
            }
            if(roleTree.elementForName("Children") != nil)
            {
               
                let Childern = roleTree.nodesForXPath("//Child", error:nil) as! [DDXMLElement]
              
                for child in Childern {
            
                if (child.elementForName("MainName") != nil && child.elementForName("MainName").stringValue() == roleTree.elementForName("RoleName").stringValue()){
                    
                    var newChild = Child()
                    if(child.elementForName("RoleCode") != nil)
                    {
                        newChild.RoleCode = child.elementForName("RoleCode").stringValue()
                    }
                    if(child.elementForName("RoleType") != nil)
                    {
                        newChild.RoleType = child.elementForName("RoleType").stringValue()
                    }
                    if(child.elementForName("ParentCode") != nil)
                    {
                        newChild.ParentCode = child.elementForName("ParentCode").stringValue()
                    }
                    if(child.elementForName("RoleName") != nil)
                    {
                        newChild.RoleName = child.elementForName("RoleName").stringValue()
                    }
                    if(child.elementForName("MainCode") != nil)
                    {
                        newChild.MainCode = child.elementForName("MainCode").stringValue()
                    }
                    if(child.elementForName("MainName") != nil)
                    {
                        newChild.MainName = child.elementForName("MainName").stringValue()
                    }
                    if(child.elementForName("PartCode") != nil)
                    {
                        newChild.PartCode = child.elementForName("PartCode").stringValue()
                    }
                    newroleTree.Childern.append(newChild)
                    }
                }
            }
            
            result.RoleTrees.append(newroleTree)
        }
        
        return result
    }
    
    
}