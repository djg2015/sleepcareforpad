//
//  TizhengViewModel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class TizhengViewModel: BaseViewModel {
    //属性定义
    var _funcSelectedIndex:Int
    // 当前功能选项卡选择的索引
    dynamic var FuncSelectedIndex:Int{
        get
        {
            return self._funcSelectedIndex
        }
        set(value)
        {
            self._funcSelectedIndex=value
        }
    }

    var _leavebedList:Array<LeavebedHistoryModel> =  Array<LeavebedHistoryModel>();
    dynamic var LeavebedList:Array<LeavebedHistoryModel>{
        get
        {
            return self._leavebedList
        }
        set(value)
        {
            self._leavebedList=value
        }
    }
    
    var _tizhengList:Array<TizhengHistoryModel> =  Array<TizhengHistoryModel>();
    dynamic var TizhengList:Array<TizhengHistoryModel>{
        get
        {
            return self._tizhengList
        }
        set(value)
        {
            self._tizhengList=value
        }
    }
    
    var _analysisTimeBegin:String = ""
    // 分析起始时间
    dynamic var AnalysisTimeBegin:String{
        get
        {
            return self._analysisTimeBegin
        }
        set(value)
        {
            self._analysisTimeBegin=value
        }
    }
    
    var _analysisTimeEnd:String = ""
    // 分析结束时间
    dynamic var AnalysisTimeEnd:String{
        get
        {
            return self._analysisTimeEnd
        }
        set(value)
        {
            self._analysisTimeEnd=value
        }
    }

    //查询分析类型
    var _searchType:String="按小时"
    dynamic var ChoosedSearchType:String{
        get
        {
            return self._searchType
        }
        set(value)
        {
            self._searchType=value
        }
    }
    
    //查询分析状态
    var _searchStatus:String="不限"
    dynamic var ChoosedSearchStatus:String{
        get
        {
            return self._searchStatus
        }
        set(value)
        {
            self._searchStatus=value
        }
    }

    var tableView:UITableView = UITableView()
     var tableView2:UITableView = UITableView()
    var searchCommand: RACCommand?
    
    
    // 初始化
    override init()
    {
 
       self._funcSelectedIndex = 0
        
       super.init()
        
       searchCommand = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Search()
        }

        
        self.AnalysisTimeBegin = Date.today().addDays(-10).description(format: "yyyy-MM-dd")
        self.AnalysisTimeEnd = Date.today().description(format: "yyyy-MM-dd")
        self.RefreshTizhengHistory()
        self.RefreshLeavebedHistory()
    }
    
    func Search() -> RACSignal{
              try {
            ({
                if(self.FuncSelectedIndex == 0){
                   self.RefreshTizhengHistory()
                }
                else{
                  self.RefreshLeavebedHistory()
                
                }
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        return RACSignal.empty()
    }

    func RefreshTizhengHistory(){
        for(var i = 0;i<20;i++){
            var test = TizhengHistoryModel()
            test.BingliCode = String(i)
            test.PatientName = "test1"
            test.BedNumber = "111"
            test.TurnTimes = "10"
            test.AvgHR = "55"
            test.AvgRR = "22"
            test.AnalysisTime = "2011－01-01 11:11"
            self._tizhengList.append(test)
        }
        self.tableView.reloadData()
    }
    
    func RefreshLeavebedHistory(){
        for(var j=0;j<20;j++){
            var test2 = LeavebedHistoryModel()
            test2.BingliCode = String(j)
            test2.PatientName = "test1"
            test2.BedNumber = "111"
            test2.BeginTime = "2011=01-01 11:11"
            test2.EndTime = "2011=01-02 11:11"
            test2.Status = "在床"
            self._leavebedList.append(test2)
        }
        self.tableView2.reloadData()

    }
    
    //自定义方法
    func SelectChange(selectIndex:Int)
    {
        self.FuncSelectedIndex = selectIndex;
    }

    //----------------------------------------
    // 在离床
    class LeavebedHistoryModel: NSObject{
        // 病例号
        var _bingliCode:String = ""
        dynamic var BingliCode:String
            {
            get
            {
                return self._bingliCode
            }
            set(value)
            {
                self._bingliCode = value
            }
        }
        
      // 名字
        var _patientName:String = ""
        dynamic var PatientName:String
            {
            get
            {
                return self._patientName
            }
            set(value)
            {
                self._patientName = value
            }
        }
        
        // 床位number
        var _bedNumber:String = ""
        dynamic var BedNumber:String
            {
            get
            {
                return self._bedNumber
            }
            set(value)
            {
                self._bedNumber = value
            }
        }
        
        // 开始时间
        var _beginTime:String = ""
        dynamic var BeginTime:String
            {
            get
            {
                return self._beginTime
            }
            set(value)
            {
                self._beginTime = value
            }
        }
        
        // 结束时间
        var _endTime:String = ""
        dynamic var EndTime:String
            {
            get
            {
                return self._endTime
            }
            set(value)
            {
                self._endTime = value
            }
        }
        // 状态
        var _status:String = ""
        dynamic var Status:String
            {
            get
            {
                return self._status
            }
            set(value)
            {
                self._status = value
            }
        }
        
        override init()
        {
            super.init();
        }
    }


    class TizhengHistoryModel: NSObject{
      
        // 病例号
        var _bingliCode:String = ""
        dynamic var BingliCode:String
            {
            get
            {
                return self._bingliCode
            }
            set(value)
            {
                self._bingliCode = value
            }
        }
        
        // 名字
        var _patientName:String = ""
        dynamic var PatientName:String
            {
            get
            {
                return self._patientName
            }
            set(value)
            {
                self._patientName = value
            }
        }
        
        // 床位number
        var _bedNumber:String = ""
        dynamic var BedNumber:String
            {
            get
            {
                return self._bedNumber
            }
            set(value)
            {
                self._bedNumber = value
            }
        }
        
        // 分析时段
        var _analysisTime:String = ""
        dynamic var AnalysisTime:String
            {
            get
            {
                return self._analysisTime
            }
            set(value)
            {
                self._analysisTime = value
            }
        }
        // 心率
        var _avgHR:String = ""
        dynamic var AvgHR:String
            {
            get
            {
                return self._avgHR
            }
            set(value)
            {
                self._avgHR = value
            }
        }
        
        // 呼吸
        var _avgRR:String = ""
        dynamic var AvgRR:String
            {
            get
            {
                return self._avgRR
            }
            set(value)
            {
                self._avgRR = value
            }
        }
        // 翻身次数
        var _turnTimes:String = ""
        dynamic var TurnTimes:String
            {
            get
            {
                return self._turnTimes
            }
            set(value)
            {
                self._turnTimes = value
            }
        }
        
        override init()
        {
            super.init();
        }
    }

}
