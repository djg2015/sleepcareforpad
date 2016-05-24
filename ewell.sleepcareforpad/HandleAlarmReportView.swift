//
//  HandleAlarmReportView.swift
//  
//
//  Created by Qinyuan Liu on 5/10/16.
//
//

import UIKit

import UIKit

class HandleAlarmReportView: UIView,PopDownListItemChoosed {

    var AlarmCode:String = ""
    var Templates:Array<String> = Array<String>()
    var parentController:UIViewController!
    var popDownList:PopDownListForIphone!
    var source:Array<PopDownListItem>=Array<PopDownListItem>()
    var handleAlarmViewModel:HandleAlarmViewModel = HandleAlarmViewModel()
    var resultText:String = ""
    
   
    @IBOutlet weak var bedUserSexLabel: UILabel!
    @IBOutlet weak var bedUserNameLabel: UILabel!
    @IBOutlet weak var bedNumberLabel: UILabel!
    @IBOutlet weak var alarmTypeLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!

    @IBOutlet weak var alarmContentText: UITextView!
    @IBOutlet weak var handleResultText: UITextView!
    @IBOutlet weak var remarkText: UITextView!
    
    @IBAction func ChooseModel(){
        
        self.popDownList.Show("选择一个模板", source:self.source)
        
    }
    
     //处理报告提交到服务器
    @IBAction func SubmitReport(){
        if self.handleResultText.text == ""{
            SweetAlert(contentHeight: 300).showAlert("报警处理结果不能为空！请继续填写", subTitle:"提示", style: AlertStyle.None,buttonTitle:"确认",buttonColor: UIColor.colorFromRGB(0xAEDEF4), action:nil)
        }
        else{
        let resultFlag =   self.handleAlarmViewModel.HandleAlarmAction("002")
 
        if resultFlag{
            //从alarmhelper中删除这条报警
          AlarmHelper.GetAlarmInstance().DeleteAlarmInfoByCode(self.AlarmCode)
        self.parentController.navigationController?.popViewControllerAnimated(true)
        }
        else{
             SweetAlert(contentHeight: 300).showAlert("报警处理操作失败！请再试一次", subTitle:"提示", style: AlertStyle.None,buttonTitle:"确认",buttonColor: UIColor.colorFromRGB(0xAEDEF4), action:nil)
        }
        }
    }
    
    //提交误报警
    @IBAction func ClickFalseAlarm(){
       
        let resultFlag =  self.handleAlarmViewModel.HandleAlarmAction("003")
        if resultFlag{
            //从alarmhelper中删除这条报警
             AlarmHelper.GetAlarmInstance().DeleteAlarmInfoByCode(self.AlarmCode)
            self.parentController.navigationController?.popViewControllerAnimated(true)
        }
            //弹窗提示处理出错
        else{
         SweetAlert(contentHeight: 300).showAlert("报警处理操作失败！请再试一次", subTitle:"提示", style: AlertStyle.None,buttonTitle:"确认",buttonColor: UIColor.colorFromRGB(0xAEDEF4), action:nil)
        }
        
    }
    
   
    func InitView(bedNumber:String,bedUserName:String,bedUserSex:String,alarmType:String,alarmTime:String,alarmContent:String,alarmCode:String,templates:Array<String>){
        self.bedNumberLabel.text = bedNumber
        self.bedUserNameLabel.text = bedUserName
        self.bedUserSexLabel.text = bedUserSex
        self.alarmContentText.text = alarmContent
        self.alarmTimeLabel.text = alarmTime
        //报警类型编号转为文字
        
        switch(alarmType){
        case "ALM_TEMPERATURE":
            self.alarmTypeLabel.text = "体温报警"
        case "ALM_HEARTBEAT":
            self.alarmTypeLabel.text = "心率报警"
        case "ALM_BREATH":
            self.alarmTypeLabel.text = "呼吸报警"
        case "ALM_BEDSTATUS":
            self.alarmTypeLabel.text = "在离床报警"
        case "ALM_FALLINGOUTOFBED":
            self.alarmTypeLabel.text = "坠床风险报警"
        case "ALM_BEDSORE":
            self.alarmTypeLabel.text = "褥疮风险报警"
        case "ALM_TEMPERATURE":
            self.alarmTypeLabel.text = "呼叫报警"
            
        default:
            self.alarmTypeLabel.text = ""
        }
       
        
        
        self.AlarmCode = alarmCode
        self.Templates = templates
        
        if(self.popDownList == nil){
            self.popDownList = PopDownListForIphone()
            self.popDownList.delegate = self
            
        
            for(var i=0;i<self.Templates.count;i++){
                var item:PopDownListItem = PopDownListItem()
                item.key = String(i)
                item.value = self.Templates[i]
                self.source.append(item)
            }
        }

       
        RACObserve(self, "AlarmCode") ~> RAC(self.handleAlarmViewModel, "AlarmCode")
        self.handleResultText.rac_textSignal() ~> RAC(self.handleAlarmViewModel, "TransferResult")
         self.remarkText.rac_textSignal() ~> RAC(self.handleAlarmViewModel, "Remark")
        
        self.alarmContentText.font = UIFont.systemFontOfSize(17)
        self.handleResultText.font = UIFont.systemFontOfSize(17)
    }

    
    func ChoosedItem(item:PopDownListItem){
        
        //获取textView的所有文本，转成可变的文本
        var mutableStr = NSMutableAttributedString(attributedString: self.handleResultText.attributedText)
        //获得目前光标的位置
        let selectedRange = self.handleResultText.selectedRange
        //插入文字
        
        mutableStr.insertAttributedString(NSAttributedString( string: item.value!), atIndex: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        //重新给文本赋值
        self.handleResultText.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.handleResultText.selectedRange = newSelectedRange
        
      self.handleAlarmViewModel.TransferResult = self.handleResultText.text
    }
    
}
