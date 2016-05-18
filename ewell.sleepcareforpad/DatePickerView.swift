//
//  DatePickerView.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable  class DatePickerView: UIView {

    var detegate:SelectDateEndDelegate!
    var datedelegate:SelectDateDelegate!
    
    var datePicker:UIDatePicker = UIDatePicker()
  //  var dateButton : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var devicebounds:CGRect = frame
        var deviceWidth:CGFloat = devicebounds.width
        var deviceHeight:CGFloat = devicebounds.height
        var viewColor:UIColor = UIColor(white:0, alpha: 0.6)
        
       
        //设置日期弹出窗口
        self.backgroundColor = viewColor
        self.userInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .Date
        datePicker.locale = NSLocale(localeIdentifier: "Chinese")
        datePicker.backgroundColor = UIColor.whiteColor()
        
        //设置 确定 和 取消 按钮
        var li_common:Li_common = Li_common()
        var selectedButton:UIButton!
        var cancelButton:UIButton!
        
         if (UIDevice.currentDevice().userInterfaceIdiom == .Phone){
        datePicker.frame = CGRect(x:deviceWidth/2-150,y:deviceHeight/2-80,width:300,height:140)
            selectedButton = li_common.Li_createButton("确定",x:deviceWidth/2-150,y:deviceHeight/2+60,width:150,height:35,target:self, action: "selectedAction")
            cancelButton = li_common.Li_createButton("取消",x:deviceWidth/2 ,y:deviceHeight/2+60,width:150,height:35,target:self, action: "cancelAction")
        }
         else{
         datePicker.frame = CGRect(x:(deviceWidth - 300)/2,y:150,width:300,height:200)
           selectedButton =  li_common.Li_createButton("确定",x:(deviceWidth - 300)/2,y:300,width:150,height:35,target:self, action: "selectedAction")
             cancelButton = li_common.Li_createButton("取消",x:(deviceWidth - 300)/2 + 150,y:300,width:150,height:35,target:self, action:"cancelAction")
        }
        
      
        self.addSubview(datePicker)
        self.addSubview(selectedButton)
        self.addSubview(cancelButton)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
 
    
    //选择日期
    func selectedAction(){
        var dateString:String = self.dateString(datePicker.date)
    //    dateButton.setTitle(dateString, forState: UIControlState.Normal)
        
        if(self.detegate != nil){
            self.detegate.SelectDateEnd(self,dateString: dateString)
        }
        if(self.datedelegate != nil){
        self.datedelegate.SelectDate(self, dateString: dateString)
        
        }
        removeAlertview()
    }
    
    func cancelAction(){
        removeAlertview()
       
    }
    
    func removeAlertview(){
        self.hidden = true
       
  
    }

    //返回2014-06-19格式的日期
    func dateString(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = dateFormatter.stringFromDate(date)
        return dateString
    }
}

protocol SelectDateEndDelegate{
    func SelectDateEnd(sender:UIView,dateString:String)
}

protocol SelectDateDelegate{
    func SelectDate(sender:UIView,dateString:String)
}
