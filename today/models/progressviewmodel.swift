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
        Task
        {
            progress.totalDeficit = await Backend.shared.GetTotalDeficit (7);
            
            let defs = await Backend.shared.GetDeficits (7);
            let count = defs.count;
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
                    progress.deficitHistory.append (DayMetric (
                        day: formatter.string(from: date),
                        metric: defs [i]
                    ))
                }
            }
        }
    }
    
    var progress: Progress = Progress (totalDeficit: 7069);
    var pDuration: eProgressDuration = .WEEK;
}
