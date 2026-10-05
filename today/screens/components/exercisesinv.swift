//
//  exercisesinv.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ExercisesInv: View
{
    @Binding
    var activities: [ListItemContent];
    
    @State
    var showAlert: Bool = false;
    
    @State
    var selected: ListItemContent?;
    
    let title = InventoryViewModel.shared.viewType == .meals ? "meal" : "workout";
    
    var body: some View
    {
        ListWithTitle (contents: activities, title: "\(activities.count) activities", pOnDelete: removeAct)
        {item in

            selected = item;
            showAlert = true;
        }
        .alert("Log \(title)?", isPresented: $showAlert)
        {
            Button ("Yes")
            {
                if selected != nil {
                    TodayViewModel.shared.activeTab = .TODAY;
                    TodayViewModel.shared.Workout (selected!);
                }
            }
            
            Button ("Cancel", role: .close) {}
        }
    }
    
    private func removeAct (_ pItem: ListItemContent) -> Void
    {
        InventoryViewModel.shared.delItem (pItem.id);
    }
}
