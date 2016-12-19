//
//  BasicinfoViewModel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class BasicinfoViewModel: BaseViewModel {
    var _hrrrRange:HRRRChart=HRRRChart()
    dynamic var HRRRRange:HRRRChart{
        get
        {
            return self._hrrrRange
        }
        set(value)
        {
            self._hrrrRange=value
        }
    }
    
    var _name:String=""
    dynamic var Name:String{
        get
        {
            return self._name
        }
        set(value)
        {
            self._name=value
        }
    }
    
    var _tel:String=""
    dynamic var Tel:String{
        get
        {
            return self._tel
        }
        set(value)
        {
            self._tel=value
        }
    }
    
    var _address:String=""
    dynamic var Address:String{
        get
        {
            return self._address
        }
        set(value)
        {
            self._address=value
        }
    }
    
    var _sex:String=""
    dynamic var Sex:String{
        get
        {
            return self._sex
        }
        set(value)
        {
            self._sex=value
        }
    }
    
    var _bingli:String=""
    dynamic var Bingli:String{
        get
        {
            return self._bingli
        }
        set(value)
        {
            self._bingli=value
        }
    }
    
    override init(){
        super.init()
        
       
  self.LoadData()
        
        
    }

    func LoadData(){
        
        var tempValueY:Array<String> = []
        var tempValueY2:Array<String> = []
        var tempValueX: Array<String> = []
        for(var i = 0; i<10; i++){
            tempValueX.append(String(i))
            tempValueY.append(String(i*10))
            tempValueY2.append(String(i*2))
        }
        self.HRRRRange.ValueY = NSArray(objects:tempValueY,tempValueY2)
        self.HRRRRange.ValueX = tempValueX
    }
    
}
//心率呼吸chart
class HRRRChart:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    
    
    var flag:Bool = true  //标志有没有chart数据
}
