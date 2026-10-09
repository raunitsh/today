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
    
    public func Sync () -> Void
    {
        withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
        {
            progress.totalDeficit = 0;
            progress.deficitHistory = [];
            progress.proteinIntake = [];
        }
        Task
        {
            let total = await Backend.shared.GetTotalDeficit (vDurationDays);
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                progress.totalDeficit = total;
            }
            
            let defs = await Backend.shared.GetDeficits (vDurationDays);
            let pros = await Backend.shared.GetProtein (vDurationDays);
            let count = defs.count;
            let calendar = Calendar.current;
            let today = Date ();
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE" // "Mon", "Tue", "Wed", etc.
            progress.deficitHistory.removeAll();
            
            if defs.count != pros.count
            {
                progress.deficitHistory = [];
                progress.proteinIntake = [];
                return;
            }
            
            for i in 0..<count
            {
                let dayOffset = -(count - 1 - i)
                
                if let date = calendar.date (byAdding: .day, value: dayOffset, to: today)
                {
                    withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
                    {
                        progress.deficitHistory.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: defs [i],
                            lineXAxis: i
                        ));
                        
                        progress.proteinIntake.append (DayMetric (
                            day: formatter.string(from: date),
                            metric: pros [i],
                            lineXAxis: i
                        ));
                    }
                }
            }
        }
    }
    
    var         progress:       Progress            = Progress (totalDeficit: 7069);
    private var vDurationDays:  Int32               = 7;
    var         uDuration:      eProgressDuration   = .WEEK;
}
