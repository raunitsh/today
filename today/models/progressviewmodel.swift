//
//  progressviewmodel.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI

@Observable
class ProgressViewModel
{
    static let shared =  ProgressViewModel ();
    
    public func UpdateTotalDeficit (_ pDays: Int32)
    {
        progress.totalDeficit = 0;
        
        Task
        {
            let n = await Backend.shared.GetTotalDeficit (pDays);
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                progress.totalDeficit = n;
            }
        }
    }
    
    public func Sync () -> Void
    {
        withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
        {
            progress.totalDeficit = 0;
            progress.deficitHistory = [];
            progress.proteinIntake = [];
            progress.calIntake = [];
        }
        Task
        {
            let total = await Backend.shared.GetTotalDeficit (uDuration == .WEEK ? 7 : 30);
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                progress.totalDeficit = total;
            }
            
            let prog = await Backend.shared.GetProgress (uDuration == .WEEK ? 7: 30);
            let count = prog.count;
            
            let calendar = Calendar.current;
            let today = Date ();
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE" // "Mon", "Tue", "Wed", etc.
            progress.deficitHistory.removeAll();
            
            for i in 0..<count
            {
                let dayOffset = -(count - 1 - i)
                
                if let date = calendar.date (byAdding: .day, value: dayOffset, to: today)
                {
                    withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
                    {
                        progress.deficitHistory.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: prog [i].deficit,
                            lineXAxis: i,
                            date: prog [i].date
                        ));
                        
                        progress.proteinIntake.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: prog [i].protein,
                            lineXAxis: i,
                            date: prog [i].date
                        ));
                        
                        progress.calIntake.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: prog [i].consumed,
                            lineXAxis: i,
                            date: prog [i].date
                        ));
                        
                        progress.activeCals.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: prog [i].active,
                            lineXAxis: i,
                            date: prog [i].date
                        ));
                    }
                }
            }
        }
    }
    
    var         progress:       Progress            = Progress (totalDeficit: 7069);
    var         uDuration:      eProgressDuration   = .WEEK;
}
