//
//  NightReport.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/6/17.
//  Copyright (c) 2017 djg. All rights reserved.
//

import Foundation
class NightReport:BaseMessage{
    var night_SignReport = nightSignReport()
    var night_SleepReport = nightSleepReport()
    var night_LeaveBedReport = nightLeaveBedReport()
    var night_SignTrend = Array<nightHourSign>()
    var night_TurnOverTrend = Array<nightTurnOver>()
    var night_AnalysisReport = nightAnalysisReport()
    
    
    //解析响应的message
    override class func XmlToMessage(subjectXml:String,bodyXMl:String) -> BaseMessage{
        let result = NightReport(messageSubject: MessageSubject.ParseXmlToSubject(subjectXml))
        //构造XML文档
        var doc = DDXMLDocument(XMLString: bodyXMl, options:0, error:nil)
        
        let nightsignreports = doc.nodesForXPath("//SignReport", error:nil) as! [DDXMLElement]
        for nightsignreport in nightsignreports{
            var temp_night_signreport = nightSignReport()
            if(nightsignreport.elementForName("AvgHR") != nil){
                temp_night_signreport.AvgHR = nightsignreport.elementForName("AvgHR").stringValue()
            }
            if(nightsignreport.elementForName("HRCompare") != nil){
                temp_night_signreport.HRCompare = nightsignreport.elementForName("HRCompare").stringValue()
            }
            if(nightsignreport.elementForName("AvgRR") != nil){
                temp_night_signreport.AvgRR = nightsignreport.elementForName("AvgRR").stringValue()
            }
            if(nightsignreport.elementForName("RRCompare") != nil){
                temp_night_signreport.RRCompare = nightsignreport.elementForName("RRCompare").stringValue()
            }
            result.night_SignReport = temp_night_signreport
        }
        
        let nightsleepreports = doc.nodesForXPath("//SleepReport", error:nil) as! [DDXMLElement]
        for nightsleepreport in nightsleepreports{
            var temp_night_sleepreport = nightSleepReport()
            if(nightsleepreport.elementForName("SleepTimespan") != nil){
                temp_night_sleepreport.SleepTimespan = nightsleepreport.elementForName("SleepTimespan").stringValue()
            }
            if(nightsleepreport.elementForName("SleepTimespanCompare") != nil){
                temp_night_sleepreport.SleepTimespanCompare = nightsleepreport.elementForName("SleepTimespanCompare").stringValue()
            }
            if(nightsleepreport.elementForName("TurnOverTimes") != nil){
                temp_night_sleepreport.TurnOverTimes = nightsleepreport.elementForName("TurnOverTimes").stringValue()
            }
            if(nightsleepreport.elementForName("TurnOverCompare") != nil){
                temp_night_sleepreport.TurnOverCompare = nightsleepreport.elementForName("TurnOverCompare").stringValue()
            }
            if(nightsleepreport.elementForName("DeepSleep") != nil){
                temp_night_sleepreport.DeepSleep = nightsleepreport.elementForName("DeepSleep").stringValue()
            }
            if(nightsleepreport.elementForName("DeepSleepCompare") != nil){
                temp_night_sleepreport.DeepSleepCompare = nightsleepreport.elementForName("DeepSleepCompare").stringValue()
            }
            if(nightsleepreport.elementForName("LightSleep") != nil){
                temp_night_sleepreport.LightSleep = nightsleepreport.elementForName("LightSleep").stringValue()
            }
            if(nightsleepreport.elementForName("LightSleepCompare") != nil){
                temp_night_sleepreport.LightSleepCompare = nightsleepreport.elementForName("LightSleepCompare").stringValue()
            }
            
            result.night_SleepReport = temp_night_sleepreport
        }

        let nightleavebedreports = doc.nodesForXPath("//LeaveBedReport", error:nil) as! [DDXMLElement]
        for nightleavebedreport in nightleavebedreports{
            var temp_night_leavebedreport = nightLeaveBedReport()
            if(nightleavebedreport.elementForName("OnBedTimespan") != nil){
                temp_night_leavebedreport.OnBedTimespan = nightleavebedreport.elementForName("OnBedTimespan").stringValue()
            }
            if(nightleavebedreport.elementForName("OnBedTimespanCompare") != nil){
                temp_night_leavebedreport.OnBedTimespanCompare = nightleavebedreport.elementForName("OnBedTimespanCompare").stringValue()
            }
            if(nightleavebedreport.elementForName("LeaveBedTimes") != nil){
                temp_night_leavebedreport.LeaveBedTimes = nightleavebedreport.elementForName("LeaveBedTimes").stringValue()
            }
            if(nightleavebedreport.elementForName("MaxLeaveBed") != nil){
                temp_night_leavebedreport.MaxLeaveBed = nightleavebedreport.elementForName("MaxLeaveBed").stringValue()
            }
            result.night_LeaveBedReport = temp_night_leavebedreport
        }
        
        let nightsigntrends = doc.nodesForXPath("//SignTrend", error:nil) as! [DDXMLElement]
        for nightsigntrend in nightsigntrends{
        let hoursigns = nightsigntrend.nodesForXPath("//HourSign", error:nil) as! [DDXMLElement]
            for hoursign in hoursigns{
            var temp_hoursign = nightHourSign()
                if(hoursign.elementForName("Hour") != nil){
                temp_hoursign.Hour = hoursign.elementForName("Hour").stringValue()
                }
                if(hoursign.elementForName("HR") != nil){
                    temp_hoursign.HR = hoursign.elementForName("HR").stringValue()
                }
                if(hoursign.elementForName("RR") != nil){
                    temp_hoursign.RR = hoursign.elementForName("RR").stringValue()
                }
                
                result.night_SignTrend.append(temp_hoursign)
            }
        }
        
        let nightturnovertrends = doc.nodesForXPath("//TurnOverTrend", error:nil) as! [DDXMLElement]
        for nightturnovertrend in nightturnovertrends{
            let turnovers = nightturnovertrend.nodesForXPath("//TurnOver", error:nil) as! [DDXMLElement]
            for turnover in turnovers{
                var temp_turnover = nightTurnOver()
                if(turnover.elementForName("Hour") != nil){
                    temp_turnover.Hour = turnover.elementForName("Hour").stringValue()
                }
                if(turnover.elementForName("TurnOverTimes") != nil){
                    temp_turnover.TurnOverTimes = turnover.elementForName("TurnOverTimes").stringValue()
                }
                
                result.night_TurnOverTrend.append(temp_turnover)
            }
        }

        
        
        let nightanalysisreports = doc.nodesForXPath("//AnalysisReport", error:nil) as! [DDXMLElement]
        for nightanalysisreport in nightanalysisreports{
        var temp_night_analysisreport = nightAnalysisReport()
            if(nightanalysisreport.elementForName("Content") != nil){
            temp_night_analysisreport.Content = nightanalysisreport.elementForName("Content").stringValue()
            }
            result.night_AnalysisReport = temp_night_analysisreport
        }
        
    return result
}

}