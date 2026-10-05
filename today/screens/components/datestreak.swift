//
//  datestreak.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct Streak: View
{
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        Button {
        } label: {
            Label("\(v.streak)", systemImage: "flame")
                .font(.footnote)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)          
        .tint(.blue)
    }
}

struct DateAndStreak: View
{
    var date: String
    {
        TodayViewModel.shared.today.date.isEmpty ? "Start Logging !" :
        formatDisplayDate (from: TodayViewModel.shared.today.date)!
    }
    
    var body: some View
    {
        HStack
        {
            VStack (alignment: .leading)
            {
                Text (date)
                    .fontDesign(.rounded)
                    .bold()
            }
            
            Spacer ()
            
            Streak ()
        }
        .frame(maxWidth: .infinity)
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
