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
    func Init () -> Void
    {
        loading = true;
        
        Task
        {
            meals = await Backend.shared.GetMealsInv ();
            activities = await Backend.shared.GetActInv ();
        }
        
        loading = false;
    }
    
    func addItem (_ pTitle: String, _ pCals: Int32) -> Void
    {
        let item = ListItemContent(title: pTitle, cals: pCals);
        
        if viewType == .meals
        {
            Task
            {
                if await Backend.shared.AddMealInv (item)
                {
                    meals.append (item);
                }
            }
            return;
        }

        Task
        {
            if await Backend.shared.AddActInv (item)
            {
                activities.append (item);
            }
        }
    }
    
    func delItem (_ pId: UUID) -> Void
    {
        if viewType == .meals
        {
            Task
            {
                if await Backend.shared.DelMealInv (pId)
                {
                    meals.removeAll { $0.id == pId }
                }
            }
            return;
        }

        Task
        {
            if await Backend.shared.DelActInv (pId)
            {
                activities.removeAll { $0.id == pId }
            }
        }
    }
    
    var viewType:   ViewType            = .meals;
    var meals:      [ListItemContent]   = [];
    var activities: [ListItemContent]   = [];
    var loading:    Bool                = false;
}
