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
        ListWithTitle (contents: meals, title: "\(meals.count) meals")
        {id in
            InventoryViewModel.shared.delItem (id)
        }
    }
}
