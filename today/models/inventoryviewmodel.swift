//
//  inventoryviewmodel.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

@Observable
class InventoryViewModel
{
    static let shared = InventoryViewModel ();
    
    @MainActor
    func LoadData () -> Void
    {
        loading = true;
        
        meals = gMeals;
        activities = gActivities;
        
        loading = false;
    }
    
    func addItem (_ pTitle: String, _ pCals: Int32) -> Void
    {
        let item = ListItemContent(title: pTitle, cals: pCals);
        
        if viewType == .meals
        {
            if Backend.shared.AddMealInv (item)
            {
                meals.append (item);
            }
            return;
        }
        
        activities.append (item);
    }
    
    var viewType:   ViewType            = .meals;
    var meals:      [ListItemContent]   = [];
    var activities: [ListItemContent]   = [];
    var loading:    Bool                = false;
}
