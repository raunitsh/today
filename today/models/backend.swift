//
//  backend.swift
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//
import coretoday
import Foundation

class Backend
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
    
    public func GetMealsInv () -> [ListItemContent]
    {
        return [];
    }
    
    private var vDb: DB = DB ();
}
