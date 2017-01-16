//
//  User.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/18.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class User:BaseMessage{
    var role:Role? = Role()
    var LoginName:String = ""
    var LoginPassword:String = ""
    var Status:String = "" // 是否启用 1.启用 2.禁用
    var MainCode:String = ""
    var PartCode:String = ""
    var WorktaskList = Array<Worktask>()
    //解析响应的message
//    注：权限编码 参考如下：
//    000001	睡眠质量分析与报表查看
//    000002	报警设置
//    000003	在离床历史查看
//    000004	历史体征查看
//    000005	权限设置
//    所属角色类型 参考如下：
//    Floor	 楼层/科室
//    Hospital	养老院/医院
    
    
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = User(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        var users = doc.nodesForXPath("//User", error:nil) as! [DDXMLElement]
        for user in users {
            if(user.elementForName("LoginName") != nil)
            {
                result.LoginName = user.elementForName("LoginName").stringValue()
            }
            if(user.elementForName("LoginPassword") != nil)
            {
                result.LoginPassword = user.elementForName("LoginPassword").stringValue()
            }
            if(user.elementForName("Status") != nil)
            {
                result.Status = user.elementForName("Status").stringValue()
            }
            if(user.elementForName("MainCode") != nil)
            {
                result.MainCode = user.elementForName("MainCode").stringValue()
            }
            if(user.elementForName("PartCode") != nil)
            {
                result.PartCode = user.elementForName("PartCode").stringValue()
            }
            if(user.elementForName("Role") != nil)
            {
                //获取role节点的子节点
                let role = user.elementForName("Role") as DDXMLElement
                if(role.elementForName("RoleCode") != nil)
                {
                    result.role?.RoleCode = role.elementForName("RoleCode").stringValue()
                }
                if(role.elementForName("RoleName") != nil)
                {
                    result.role?.RoleName = role.elementForName("RoleName").stringValue()
                }
                if(role.elementForName("RoleType") != nil)
                {
                    result.role?.RoleType = role.elementForName("RoleType").stringValue()
                }
            }
            var worktasks = doc.nodesForXPath("//Worktask", error:nil) as? [DDXMLElement]
            if(worktasks != nil){
            for worktask in worktasks! {
                var newWorktask = Worktask()
                if(worktask.elementForName("WorktaskCode") != nil)
                {
                    newWorktask.WorktaskCode = worktask.elementForName("WorktaskCode").stringValue()
                }
                if(worktask.elementForName("WorktaskName") != nil)
                {
                    newWorktask.WorktaskName = worktask.elementForName("WorktaskName").stringValue()
                }
                result.WorktaskList.append(newWorktask)
            }
            }
        }
        return result
    }
    
}