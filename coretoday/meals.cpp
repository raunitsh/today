//
//  meals.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"
#include <iostream>

bool
DB::DelMealInv (const std::string &pId)
{
        const char *    q = "UPDATE meals SET del = 1 WHERE id = ?;";
        sqlite3_stmt *  st = nullptr;
        bool            rc = false;
    
    if (!vDb)
    {
        return false;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text(st, 1, pId.c_str (), -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(st) == SQLITE_DONE)
    {
        rc = (sqlite3_changes (vDb) > 0);
    }
    
    sqlite3_finalize(st);
    
    return rc;
}

std::vector<tListItemContent>
DB::GetMealsInv ()
{
        std::vector<tListItemContent>   res;
        const char *                    sql = nullptr;
        sqlite3_stmt*                   st = nullptr;
    
    if (!vDb)
    {
        return res;
    }
    
    sql = "SELECT id, title, cals FROM meals WHERE del = 0;";
    
    if (sqlite3_prepare_v2(vDb, sql, -1, &st, nullptr) == SQLITE_OK)
    {
        while (sqlite3_step (st) == SQLITE_ROW)
        {
            tListItemContent meal;
            
            const unsigned char * id = sqlite3_column_text(st, 0);
            const unsigned char * title = sqlite3_column_text(st, 1);
            int cals = sqlite3_column_int(st, 2);
            
            meal.uId = id ? (const char *)id : "";
            meal.uTitle = title ? (const char *)title : "";
            meal.uCals = cals;
            
            res.push_back (meal);
        }
        sqlite3_finalize(st);
    }
    
    return res;
}

bool
DB::AddMealInv(const std::string &pId, const std::string &pTitle, const int &pCals)
{
        const char *    q = nullptr;
        sqlite3_stmt*   st = nullptr;
        bool            rc;
    
    if (!vDb)
    {
        return false;
    }
    
    q = "INSERT OR REPLACE INTO meals (id, title, cals) VALUES (?, ?, ?);";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text (st, 1, pId.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text (st, 2, pTitle.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int (st, 3, pCals);
    
    rc = (sqlite3_step (st) == SQLITE_DONE);
    return rc;
}

// find meal
// find bmr
// create today's date
// find today's entry
// if found -> update entry with cals
// if not found -> insert new entry with vals
bool
DB::LogMeal (const std::string& pMealId)
{
        int meal_cals = -1;
        int bmr = -1;
        const char * q = "SELECT cals FROM meals WHERE id = ?;";
        sqlite3_stmt * st_meal;
        sqlite3_stmt * st_bmr;
    
    if (!vDb)
    {
        return false;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_meal, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text(st_meal, 1, pMealId.c_str (), -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(st_meal) == SQLITE_ROW)
    {
        meal_cals = sqlite3_column_int (st_meal, 0);
    }
    
    if (meal_cals == -1)
    {
        return false;
    }
    
    sqlite3_finalize(st_meal);
    
    q = "SELECT bmr FROM profile WHERE id = 1;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_bmr, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    while (sqlite3_step(st_bmr) == SQLITE_ROW)
    {
        bmr = sqlite3_column_int (st_bmr, 0);
    }
    
    if (bmr == -1)
    {
        return false;
    }
    
    std::cout << "Meal cals are: " << meal_cals << " and bmr is: " << bmr;
    
    return true;
}
