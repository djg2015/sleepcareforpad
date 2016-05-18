//
//  MainAndPartInfoHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 3/30/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation

//每次点击标题从服务器重新拉取当前账户下养老院和科室名
func GetMainAndPartInfo(){
    try {
        ({
           
                var playe:Array<Play> = Array<Play>()
                var playDictionariesArray:Array<RoleTree>?
                var partcodeDictionary = Dictionary<String,partandmainInfo>()
                var session = Session.GetSession()
            
                if (session != nil && session!.LoginUser!.role!.RoleCode != ""){
                    //获取养老院和科室信息
                    var  roletree = SleepCareBussiness().TreeRolesByRoleCode(session!.LoginUser!.role!.RoleCode)
                    
                    //为session里的mainandpartArraylist赋值
                    if roletree.RoleTrees.count > 0{
                        playDictionariesArray = roletree.RoleTrees
                        //playDictionary是每个养老院
                        for playDictionary in playDictionariesArray! {
                            
                            //养老院节点
                            if playDictionary.RoleType == "Hospital"{
                                //每个养老院和其下科室封装成play对象
                                var play: Play = Play()
                                play.name = playDictionary.MainName
                                //partnameDictionaries是某一养老院下的科室
                                var partnameDictionaries:Array<Child> = playDictionary.Childern
                                var parts = Array<Part>()
                                //每个科室封装成part对象
                                for partDictionary in partnameDictionaries {
                                    var part: Part = Part()
                                    part.partname = partDictionary.RoleName
                                    part.partcode = partDictionary.PartCode
                                    parts.append(part)
                                    
                                    //向partcodeDictionary中添加值，key：partcode，value：partandmainInfo（）
                                    var info = partandmainInfo()
                                    info.partcode = partDictionary.PartCode
                                    info.partname = partDictionary.RoleName
                                    info.mainname = partDictionary.MainName
                                    partcodeDictionary[partDictionary.PartCode] = info
                                }
                                play.partnames = parts
                                playe.append(play)
                            }
                                //科室节点
                            else if playDictionary.RoleType == "Floor"{
                                var part = Part()
                                var play = Play()
                                play.name = playDictionary.MainName
                                part.partcode = playDictionary.PartCode
                                part.partname = playDictionary.RoleName
                                play.partnames.append(part)
                                playe.append(play)
                                
                            }
                        }//end for
                        
                        session!.MainAndPartArrayList = playe
                        session!.PartcodeDictionary = partcodeDictionary
                    }
                }
                
                
            
            },
            catch: { ex in
                //异常处理
                handleException(ex,showDialog: true)
            },
            finally: {
                
            }
        )}
    
}