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
    
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {
                    CurrentStats (stats: v.today, bmr: UserViewModel.shared.userProfile?.bmr ?? 0);
                    TodayTimeline (timeline: v.timeline, readonly: false, deleteTimelineItem: v.deleteTimelineItem);
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
}
