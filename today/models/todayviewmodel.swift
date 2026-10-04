//
//  todayviewmodel.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

@Observable
class TodayViewModel
{
    static let shared = TodayViewModel ();
    
    func Init () -> Void
    {
        Task
        {
            today = await Backend.shared.GetToday ();
            eatenToday = await Backend.shared.GetTodayMeals ();
        }
    }
    
    func EatMeal (_ pMeal: ListItemContent) -> Void
    {
        Task
        {
            if await Backend.shared.LogMeal (pMeal.id)
            {
                eatenToday.append (pMeal);
            }
        }
    }
    
    func Workout (_ pAct: ListItemContent) -> Void
    {
        actToday.append (pAct);
    }
    
    var streak:     Int               = 12;
    var today:      Today             = Today (date: "", deficit: 0, consumed: 0, updated: 0);
    var eatenToday: [ListItemContent] = [];
    var actToday:   [ListItemContent] = [];
}
