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
    
    func Sync () -> Void
    {
        withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
        {
            today = Today(date: "", deficit: 0, consumed: 0, protein: 0, active: 0, updated: 0);
            timeline = [];
        }
        
        Task
        {
            let t = await Backend.shared.GetToday ();
            let tm = await Backend.shared.GetTodayTimeline ();
            
            withAnimation (.spring (response: 0.35, dampingFraction: 0.8))
            {
                self.today = t;
                self.timeline = tm;
            }
        }
    }

    func deleteTimelineItem (_ item: ListItemContent)
    {
        Task
        {
            let success: Bool
            
            if item.type == .meal
            {
                success = await Backend.shared.UnLogMeal (item.recordId)
            } else
            {
                success = await Backend.shared.UnLogAct (item.recordId)
            }
            
            if success
            {
                Sync()
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
    var timeline:   [ListItemContent] = [];
    var activeTab:  eTab              = .TODAY;
}
