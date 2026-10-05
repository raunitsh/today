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
            let t = await Backend.shared.GetToday ();
            let m = await Backend.shared.GetTodayMeals ();
            let a = await Backend.shared.GetTodayActivities ();
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                self.today = t;
                self.eatenToday = m;
                self.actToday = a;
            }
        }
    }
    
    func EatMeal (_ pMeal: ListItemContent) -> Void
    {
        Task
        {
            if await Backend.shared.LogMeal (pMeal.id)
            {
                today = await Backend.shared.GetToday ();
                eatenToday = await Backend.shared.GetTodayMeals ();
            }
        }
    }
    
    func DeleteMeal (_ pMeal: ListItemContent) -> Void
    {
        Task
        {
            if await Backend.shared.UnLogMeal (pMeal.recordId)
            {
                today = await Backend.shared.GetToday ();
                eatenToday = await Backend.shared.GetTodayMeals ();
            }
        }
    }
    
    func Workout (_ pAct: ListItemContent) -> Void
    {
        Task
        {
            if await Backend.shared.LogAct (pAct.id)
            {
                today = await Backend.shared.GetToday ();
                actToday = await Backend.shared.GetTodayActivities ();
            }
        }
    }
    
    func DeleteWorkout (_ pAct: ListItemContent) -> Void
    {
        Task
        {
            if await Backend.shared.UnLogAct (pAct.recordId)
            {
                today = await Backend.shared.GetToday ();
                actToday = await Backend.shared.GetTodayActivities ();
            }
        }
    }
    
    var streak:     Int               = 12;
    var today:      Today             = Today (date: "", deficit: 0, consumed: 0, protein: 0, active: 0, updated: 0);
    var eatenToday: [ListItemContent] = [];
    var actToday:   [ListItemContent] = [];
    var activeTab:  eTab              = .TODAY;
}
