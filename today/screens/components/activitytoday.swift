//
//  activitytoday.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ActivityToday: View
{
    @Bindable
    var v = TodayViewModel.shared;
    
    @State
    var showAlert: Bool = false;
    
    @State
    var selected: ListItemContent?;
    
    var body: some View
    {
        ListWithTitle (contents: v.actToday, title: "Activity", pOnDelete: removeAct, rightVal: TodayViewModel.shared.today.active, rightUnit: "kcal")
        {_ in
            // No tap action needed here
        }
        .alert("Delete log?", isPresented: $showAlert)
        {
            Button ("Yes")
            {
                if selected != nil {
                    TodayViewModel.shared.DeleteWorkout (selected!);
                }
            }
            
            Button ("Cancel", role: .close) {}
        }
    }
    
    private func removeAct (_ pItem: ListItemContent) -> Void
    {
        selected = pItem;
        showAlert = true;
    }
}
