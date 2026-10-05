//
//  mealsinv.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct MealsInv: View
{
    @Binding
    var meals: [ListItemContent];
    
    @State
    var showAlert: Bool = false;
    
    @State
    var selected: ListItemContent?;
    
    let title = InventoryViewModel.shared.viewType == .meals ? "meal" : "workout";
    
    var body: some View
    {
        ListWithTitle (contents: meals, title: "\(meals.count) meals", pOnDelete: removeItem)
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
                    TodayViewModel.shared.EatMeal (selected!);
                }
            }
            
            Button ("Cancel", role: .close) {}
        }
    }
    
    private func removeItem (_ pItem: ListItemContent)
    {
        InventoryViewModel.shared.delItem (pItem.id);
    }
}
