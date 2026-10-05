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
    var deleteAlert: Bool = false;
    
    @State
    var selected: ListItemContent?;
    
    let title = InventoryViewModel.shared.viewType == .meals ? "meal" : "workout";
    
    var body: some View
    {
        ListWithTitle (contents: meals, title: "\(meals.count) meals", pOnDelete: removeItem, rightVal: 0, rightUnit: "")
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
        .alert("Delete \(title)?", isPresented: $deleteAlert)
        {
            Button ("Delete")
            {
                if selected != nil {
                    deleteAlert = false;
                    InventoryViewModel.shared.delItem (selected!.id);
                }
            }
            
            Button ("Cancel", role: .close) {}
        }
    }
    
    private func removeItem (_ pItem: ListItemContent)
    {
        selected = pItem;
        deleteAlert = true;
    }
}
