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
    
    var body: some View
    {
        ListWithTitle (contents: meals, title: "\(meals.count) meals", pOnDelete: removeItem)
        {item in

            TodayViewModel.shared.EatMeal (item);
        }
    }
    
    private func removeItem (_ pId: UUID)
    {
        InventoryViewModel.shared.delItem (pId);
    }
}
