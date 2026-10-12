//
//  summary.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct SummaryScreen: View
{
    @State
    var resetAlert = false;
    
    var date: String
    {
        TodayViewModel.shared.today.date.isEmpty ? "Start Logging !" :
        formatDisplayDate (from: TodayViewModel.shared.today.date)!
    }
    
    @Binding
    var currTab: eTab;
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {
                    CurrentStats ();
                    TodayTimeline ();
//                    EatenToday ();
//                    ActivityToday ();
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
            .onChange(of: currTab)
            {_, newtab in
                
                if newtab == .TODAY
                {
                    Task { TodayViewModel.shared.Sync () }
                }
            }
        }
        .navigationTitle(date)
        .toolbar
        {
            ToolbarItem (placement: .topBarTrailing)
            {
                Button ("reset", systemImage: "arrow.counterclockwise")
                {
                    resetAlert = true;
                }
                .labelStyle(.iconOnly)
                .tint (.blue)
            }
        }
        .alert("Reset Today?", isPresented: $resetAlert)
        {
            Button ("Yes")
            {
                resetAlert = false;
                TodayViewModel.shared.resetToday ();
            }
            
            Button ("Cancel", role: .close) {}
        }
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
