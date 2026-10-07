//
//  summary.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct SummaryScreen: View
{
    var date: String
    {
        TodayViewModel.shared.today.date.isEmpty ? "Start Logging !" :
        formatDisplayDate (from: TodayViewModel.shared.today.date)!
    }
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {   
                    CurrentStats ();
                    EatenToday ();
                    ActivityToday ();
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
        }.navigationTitle(date);
    }
    
    func formatDisplayDate (from dateString: String) -> String?
    {
        let parseStrategy = Date.ISO8601FormatStyle()
            .year().month().day()
            .dateSeparator(.dash)
        
        guard let date = try? Date(dateString, strategy: parseStrategy) else {
            return nil
        }
        
        // Formats into: EEE d MMM (e.g., "Fri 2 Oct")
        return date.formatted(
            .dateTime
                .weekday(.abbreviated)
                .day()
                .month(.abbreviated)
        )
    }
}
