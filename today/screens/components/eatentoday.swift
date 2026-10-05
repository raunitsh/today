//
//  eatentodayy.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct EatenToday: View
{
    @Bindable
    var v = TodayViewModel.shared;
    
    @State
    var showAlert: Bool = false;
    
    @State
    var selected: ListItemContent?;
    
    var body: some View
    {
        ListWithTitle(contents: v.eatenToday, title: "Eaten today", pOnDelete: removeItem, rightVal: TodayViewModel.shared.today.consumed, rightUnit: "kcal")
        {_ in
            // No tap action needed here
        }
        .alert("Delete log?", isPresented: $showAlert)
        {
            Button ("Yes")
            {
                if selected != nil {
                    TodayViewModel.shared.DeleteMeal (selected!);
                }
            }
            
            Button ("Cancel", role: .close) {}
        }
    }
    
    private func removeItem (_ pItem: ListItemContent) -> Void
    {
        selected = pItem;
        showAlert = true;
    }
}
