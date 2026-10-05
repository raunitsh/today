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
    
    public func GetTotalDeficit (_ pDays: Int32) -> Int32
    {
        return -vDb.GetTotalDeficit (pDays);
    }
    
    public func GetDeficits (_ pDays: Int32) -> [Int32]
    {
        let res = vDb.GetDeficits (pDays);
        var defs: [Int32] = [];
        
        for d in res
        {
            defs.append(-d);
        }
        
        return defs;
    }
    
    public func GetTodayMeals () -> [ListItemContent]
    {
        let res = vDb.GetTodayMeals ();
        var meals: [ListItemContent] = [];
        
        for item in res
        {
            meals.append(ListItemContent(
                recordId: item.uRecordId,
                title: String (item.uTitle),
                cals: item.uCals,
                protein: item.uProtein,
                icon: String (item.uIcon)
            ));
        }
        
        return meals;
    }
    
    public func GetTodayActivities () -> [ListItemContent]
    {
        let res = vDb.GetTodayEx ();
        var act: [ListItemContent] = [];
        
        for item in res
        {
            act.append(ListItemContent(
                recordId: item.uRecordId,
                title: String (item.uTitle),
                cals: item.uCals,
                protein: 0,
                icon: String (item.uIcon)
            ));
        }
        
        return act;
    }
    
    public func GetToday () -> Today
    {
        let res: tToday =  vDb.GetToday ();
        
        return Today (
            date: String (res.uDate),
            deficit: res.uDeficit,
            consumed: res.uConsumed,
            protein: res.uProtein,
            active: res.uActive,
            updated: res.uUpdated
        );
    }
    
    public func LogMeal (_ pMealId: UUID) -> Bool
    {
        return vDb.LogMeal (std.string (pMealId.uuidString));
    }
    
    public func UnLogMeal (_ pRecordId: Int32) -> Bool
    {
        return vDb.UnLogMeal (pRecordId);
    }
    
    public func LogAct (_ pActId: UUID) -> Bool
    {
        return vDb.LogEx (std.string (pActId.uuidString));
    }
    
    public func UnLogAct (_ pRecordId: Int32) -> Bool
    {
        return vDb.UnLogEx (pRecordId);
    }
    
    public func LoadProfile () -> UserProfile
    {
        let prof = vDb.GetProf ();
        
        return UserProfile (
            name: String (prof.uName),
            age: prof.uAge,
            weight: prof.uWeight,
            height: prof.uHeight,
            bmr: prof.uBmr
        );
    }
    
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
        let icon = std.string (pMeal.icon);
        
        return vDb.AddMealInv(id, title, cals, pMeal.protein, icon);
    }
    
    public func AddActInv (_ pMeal: ListItemContent) -> Bool
    {
        let title = std.string (pMeal.title);
        let cals = pMeal.cals;
        let id = std.string (pMeal.id.uuidString);
        let icon = std.string (pMeal.icon);
        
        return vDb.AddExInv (id, title, cals, icon);
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
            let icon = String (meal.uIcon);
            
            meals.append (ListItemContent (
                id: id,
                title: title,
                cals: cals,
                protein: meal.uProtein,
                icon: icon)
            )
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
                cals: act.uCals,
                protein: 0,
                icon: String (act.uIcon)
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
