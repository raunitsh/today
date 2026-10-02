//
//  backend.swift
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//
import coretoday
import Foundation

actor Backend
{
    static let shared = Backend ();
    
    public func Init (_ pDocUrl: URL) -> Bool
    {
        let dbUrl = pDocUrl.appendingPathComponent ("today_db.sqlite");
        let path = std.string (dbUrl.path);
        
        if vDb.Open (path)
        {
            print ("DB opened at: \(dbUrl.path)")
            return true;
        }

        return false;
    }
    
    public func AddMealInv (_ pMeal: ListItemContent) -> Bool
    {
        let title = std.string (pMeal.title);
        let cals = pMeal.cals;
        let id = std.string (pMeal.id.uuidString);
        
        return vDb.AddMealInv(id, title, cals);
    }
    
    public func AddActInv (_ pMeal: ListItemContent) -> Bool
    {
        let title = std.string (pMeal.title);
        let cals = pMeal.cals;
        let id = std.string (pMeal.id.uuidString);
        
        return vDb.AddExInv (id, title, cals);
    }
    
    public func GetMealsInv () -> [ListItemContent]
    {
        let res = vDb.GetMealsInv ();
        var meals: [ListItemContent] = [];
        
        for meal in res
        {
            let title = String (meal.uTitle);
            let id = UUID(uuidString: String (meal.uId)) ?? UUID ();
            let cals = meal.uCals;
            
            meals.append (ListItemContent (id: id, title: title, cals: cals))
        }
        
        return meals;
    }
    
    public func GetActInv () -> [ListItemContent]
    {
        return vDb.GetExInv().map
        { act in
            ListItemContent(
                id: UUID(uuidString: String(act.uId)) ?? UUID(),
                title: String(act.uTitle),
                cals: act.uCals
            )
        }
    }
    
    public func DelMealInv (_ pId: UUID) -> Bool
    {
        return vDb.DelMealInv (std.string (pId.uuidString));
    }
    
    public func DelActInv (_ pId: UUID) -> Bool
    {
        return vDb.DelExInv (std.string (pId.uuidString));
    }
    
    private var vDb: DB = DB ();
}
