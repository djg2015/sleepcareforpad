//
//  YejianViewController.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class YejianViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var lblTopname: UILabel!
    @IBOutlet weak var lblEquipmentID: UILabel!
    
    @IBOutlet weak var mainscrollview: UIScrollView!
    
    var hrrrcontainer:UIView!
    var turnovercontainer:UIView!
   var scrollviewWidth:CGFloat = 0.0
    var yejianViewModel:YejianViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yejianViewModel = YejianViewModel()
        
        scrollviewWidth = self.mainscrollview.frame.size.width
        self.mainscrollview.delegate = self
        self.mainscrollview.contentSize = CGSize(width:scrollviewWidth,height:1050)
    
        self.lblTopname.text = Session.GetSession()!.CurUserName
        self.lblEquipmentID.text = Session.GetSession()!.CurEquipmentID
        
        
        self.InitUISettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitUISettings(){
        var tizhengView = UIView(frame:CGRectMake(0, 0, scrollviewWidth, 160))
         var sleepView = UIView(frame:CGRectMake(0, 160, scrollviewWidth, 160))
         var onoffbedView = UIView(frame:CGRectMake(0, 320, scrollviewWidth, 80))
         var hrrrView = UIView(frame:CGRectMake(0, 400, scrollviewWidth, 300))
         var turnoverView = UIView(frame:CGRectMake(0, 700, scrollviewWidth, 300))
         var analysisView = UIView(frame:CGRectMake(0, 1000, scrollviewWidth, 40))
        
        self.mainscrollview.addSubview(tizhengView)
        self.mainscrollview.addSubview(sleepView)
        self.mainscrollview.addSubview(onoffbedView)
        self.mainscrollview.addSubview(hrrrView)
        self.mainscrollview.addSubview(turnoverView)
        self.mainscrollview.addSubview(analysisView)
        
        //---------------
        var tizhengTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 160))
        tizhengTitle.text = "夜间体征情况"
        var avgturnoverTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5, 40))
        avgturnoverTitle.text = "平均翻身"
        var avghrTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 40, scrollviewWidth/5, 40))
        avghrTitle.text = "平均心率"
        var avgrrTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 80, scrollviewWidth/5, 40))
        avgrrTitle.text = "平均呼吸"
        var avgtempTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 120, scrollviewWidth/5, 40))
        avgtempTitle.text = "平均体温"
        var avgturnoverData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 0, scrollviewWidth/5, 40))
         var avghrData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 40, scrollviewWidth/5, 40))
         var avgrrData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 80, scrollviewWidth/5, 40))
         var avgtempData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 120, scrollviewWidth/5, 40))
        var avgturnoverTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 0, scrollviewWidth/5, 40))
        avgturnoverTitle2.text = "与前夜相比"
        var avghrTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 40, scrollviewWidth/5, 40))
        avghrTitle2.text = "与前夜相比"
        var avgrrTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 80, scrollviewWidth/5, 40))
        avgrrTitle2.text = "与前夜相比"
        var avgtempTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 120, scrollviewWidth/5, 40))
        avgtempTitle2.text = "与前夜相比"
        var avgturnoverData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 0, scrollviewWidth/5, 40))
        var avghrData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 40, scrollviewWidth/5, 40))
        var avgrrData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 80, scrollviewWidth/5, 40))
        var avgtempData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 120, scrollviewWidth/5, 40))

        tizhengView.addSubview(tizhengTitle)
        tizhengView.addSubview(avgturnoverTitle)
         tizhengView.addSubview(avghrTitle)
         tizhengView.addSubview(avgrrTitle)
         tizhengView.addSubview(avgtempTitle)
        tizhengView.addSubview(avgturnoverData)
        tizhengView.addSubview(avghrData)
        tizhengView.addSubview(avgrrData)
        tizhengView.addSubview(avgtempData)
        tizhengView.addSubview(avgturnoverTitle2)
        tizhengView.addSubview(avghrTitle2)
        tizhengView.addSubview(avgrrTitle2)
        tizhengView.addSubview(avgtempTitle2)
        tizhengView.addSubview(avgturnoverData2)
        tizhengView.addSubview(avghrData2)
        tizhengView.addSubview(avgrrData2)
        tizhengView.addSubview(avgtempData2)
        //--------------
        var sleepTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 160))
        sleepTitle.text = "夜间睡眠情况"
        var sleeptimeTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5, 40))
        sleeptimeTitle.text = "睡眠时间段"
        var totalturnTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 40, scrollviewWidth/5, 40))
        totalturnTitle.text = "翻身总次数"
        var deepsleepTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 80, scrollviewWidth/5, 40))
        deepsleepTitle.text = "深睡时长"
        var lightsleepTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 120, scrollviewWidth/5, 40))
        lightsleepTitle.text = "浅睡时长"
        var sleeptimeData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 0, scrollviewWidth/5, 40))
        var totalturnData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 40, scrollviewWidth/5, 40))
        var deepsleepData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 80, scrollviewWidth/5, 40))
        var lightsleepData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 120, scrollviewWidth/5, 40))
        var sleeptimeTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 0, scrollviewWidth/5, 40))
        sleeptimeTitle2.text = "与前夜相比"
        var totalturnTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 40, scrollviewWidth/5, 40))
        totalturnTitle2.text = "与前夜相比"
        var deepsleepTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 80, scrollviewWidth/5, 40))
        deepsleepTitle2.text = "与前夜相比"
        var lightsleepTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 120, scrollviewWidth/5, 40))
        lightsleepTitle2.text = "与前夜相比"
        var sleeptimeData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 0, scrollviewWidth/5, 40))
        var totalturnData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 40, scrollviewWidth/5, 40))
        var deepsleepData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 80, scrollviewWidth/5, 40))
        var lightsleepData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 120, scrollviewWidth/5, 40))

        sleepView.addSubview(sleepTitle)
         sleepView.addSubview(sleeptimeTitle)
         sleepView.addSubview(totalturnTitle)
         sleepView.addSubview(deepsleepTitle)
         sleepView.addSubview(lightsleepTitle)
         sleepView.addSubview(sleeptimeData)
         sleepView.addSubview(totalturnData)
         sleepView.addSubview(deepsleepData)
         sleepView.addSubview(lightsleepData)
        sleepView.addSubview(sleeptimeTitle2)
        sleepView.addSubview(totalturnTitle2)
        sleepView.addSubview(deepsleepTitle2)
        sleepView.addSubview(lightsleepTitle2)
        sleepView.addSubview(sleeptimeData2)
        sleepView.addSubview(totalturnData2)
        sleepView.addSubview(deepsleepData2)
        sleepView.addSubview(lightsleepData2)
        //---------------
        var onoffbedTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 80))
        onoffbedTitle.text = "夜间在／离床情况"
        var onbedTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5, 40))
        onbedTitle.text = "在床时长"
        var leavebedTitle = TableLabel(frame:CGRectMake(scrollviewWidth/5, 40, scrollviewWidth/5, 40))
        leavebedTitle.text = "离床次数"
        var onbedData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 0, scrollviewWidth/5, 40))
        var leavebedData = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*2, 40, scrollviewWidth/5, 40))
        var onbedTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 0, scrollviewWidth/5, 40))
        onbedTitle2.text = "与前夜相比"
        var leavebedTitle2 = TableLabel(frame:CGRectMake(scrollviewWidth/5*3, 40, scrollviewWidth/5, 40))
        leavebedTitle2.text = "与前夜相比"
        var onbedData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 0, scrollviewWidth/5, 40))
        var leavebedData2 = TableDataLabel(frame:CGRectMake(scrollviewWidth/5*4, 40, scrollviewWidth/5, 40))
        
        onoffbedView.addSubview(onoffbedTitle)
         onoffbedView.addSubview(onbedTitle)
         onoffbedView.addSubview(leavebedTitle)
         onoffbedView.addSubview(onbedData)
         onoffbedView.addSubview(leavebedData)
        onoffbedView.addSubview(onbedTitle2)
        onoffbedView.addSubview(leavebedTitle2)
        onoffbedView.addSubview(onbedData2)
        onoffbedView.addSubview(leavebedData2)
        //---------------
        var hrrrTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 300))
        hrrrTitle.text = "夜间心率／呼吸趋势图"
        hrrrcontainer = UIView(frame:CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5*4, 300))
        hrrrcontainer.layer.borderWidth = 1
        hrrrcontainer.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor

        hrrrView.addSubview(hrrrcontainer)
        hrrrView.addSubview(hrrrTitle)
        
        //---------------
        var turnoverTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 300))
        turnoverTitle.text = "夜间翻身趋势图"
        turnovercontainer = UIView(frame:CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5*4, 300))
        turnovercontainer.layer.borderWidth = 1
        turnovercontainer.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        
        turnoverView.addSubview(turnoverTitle)
        turnoverView.addSubview(turnovercontainer)
        //---------------
        var analysisTitle = TableLabel(frame:CGRectMake(0, 0, scrollviewWidth/5, 40))
        analysisTitle.text = "系统分析"
        var analysisData = TableDataLabel(frame: CGRectMake(scrollviewWidth/5, 0, scrollviewWidth/5*4, 40))
         analysisView.addSubview(analysisData)
        analysisView.addSubview(analysisTitle)
    }

}
