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
            progress.calIntake = [];
            progress.activeCals = [];
        }
        Task
        {
            let daysToFetch: Int32 = uDuration == .WEEK ? 7 : 28;
            let total = await Backend.shared.GetTotalDeficit (daysToFetch);
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                progress.totalDeficit = total;
            }
            
            let prog = await Backend.shared.GetProgress (daysToFetch);
            let count = prog.count;
            
            let calendar = Calendar.current;
            let today = Date ();
            let formatter = DateFormatter()
            
            progress.deficitHistory.removeAll();
            progress.proteinIntake.removeAll();
            progress.calIntake.removeAll();
            progress.activeCals.removeAll();
            
            if uDuration == .WEEK
            {
                formatter.dateFormat = "EEE" // "Mon", "Tue", "Wed", etc.
                
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
            else
            {
                // MONTH: 4 weekly averages like Strava
                let daysPerWeek = 7;
                var weeks: [[Today]] = [];
                var currentWeek: [Today] = [];
                
                for (index, item) in prog.enumerated()
                {
                    currentWeek.append(item);
                    if currentWeek.count == daysPerWeek || index == count - 1
                    {
                        weeks.append(currentWeek);
                        currentWeek = [];
                    }
                }
                
                for (w, weekItems) in weeks.enumerated()
                {
                    let weekCount = Int32(weekItems.count);
                    guard weekCount > 0 else { continue }
                    
                    let avgDeficit = weekItems.reduce(0) { $0 + $1.deficit } / weekCount;
                    let avgProtein = weekItems.reduce(0) { $0 + $1.protein } / weekCount;
                    let avgConsumed = weekItems.reduce(0) { $0 + $1.consumed } / weekCount;
                    let avgActive = weekItems.reduce(0) { $0 + $1.active } / weekCount;
                    
                    let firstDate = weekItems.first?.date ?? "";
                    let lastDate = weekItems.last?.date ?? "";
                    
                    let shortStart = self.formatShortDate(firstDate);
                    let shortEnd = self.formatShortDate(lastDate);
                    let dateRange = "\(shortStart) – \(shortEnd)";
                    let weekLabel = "W\(w + 1)";
                    
                    withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
                    {
                        progress.deficitHistory.append (DayMetric (
                            day: weekLabel,
                            metric: avgDeficit,
                            lineXAxis: w,
                            date: dateRange
                        ));
                        
                        progress.proteinIntake.append (DayMetric (
                            day: weekLabel,
                            metric: avgProtein,
                            lineXAxis: w,
                            date: dateRange
                        ));
                        
                        progress.calIntake.append (DayMetric (
                            day: weekLabel,
                            metric: avgConsumed,
                            lineXAxis: w,
                            date: dateRange
                        ));
                        
                        progress.activeCals.append (DayMetric (
                            day: weekLabel,
                            metric: avgActive,
                            lineXAxis: w,
                            date: dateRange
                        ));
                    }
                }
            }
        }
    }
    
    private func formatShortDate (_ dateString: String) -> String
    {
        let parseStrategy = Date.ISO8601FormatStyle()
            .year().month().day()
            .dateSeparator(.dash)
        
        guard let date = try? Date(dateString, strategy: parseStrategy) else {
            return dateString
        }
        
        return date.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
        )
    }
    
    var         progress:       Progress            = Progress (totalDeficit: 7069);
    var         uDuration:      eProgressDuration   = .WEEK
    {
        didSet
        {
            Sync()
        }
    }
}
