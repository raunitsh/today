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
    
    @MainActor
    func Init () -> Void
    {
        
    }
    
    // push meal today
    // log in backend
    func EatMeal (_ pMeal: ListItemContent) -> Void
    {
        Task
        {
            await Backend.shared.LogMeal (pMeal.id);
        }
        
//        eatenToday.append (pMeal);
    }
    
    func Workout (_ pAct: ListItemContent) -> Void
    {
        actToday.append (pAct);
    }
    
    var date:       String            = "Fri 2 Oct";
    var streak:     Int               = 12;
    var burn:       Int               = 2190;
    var eaten:      Int               = 1150;
    var eatenToday: [ListItemContent] = [];
    var actToday:   [ListItemContent] = [];
    var deficit:    Int
    {
        eaten - burn
    }
}
