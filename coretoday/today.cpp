//
//  today.cpp
//  today
//
//  Created by Raunit Shrivastava on 04/10/26.
//

#include "db.hpp"
#include "utils.hpp"

#include <iostream>

tToday
DB::GetToday ()
{
        tToday res;
        const char * q = "SELECT date, deficit, consumed, updated_at FROM today WHERE date = ?;";
        sqlite3_stmt * st;
        char * date;
        
    if (!vDb)
    {
        return {};
    }

    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return {};
    }
    
    date = new char [11];
    GetTodayDate (date);
    
    sqlite3_bind_text(st, 1, date, -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(st) != SQLITE_ROW)
    {
        // No record
        delete[] date;
        sqlite3_finalize (st);
        return {};
    }
    
    res.uDate = date;
    res.uDeficit = sqlite3_column_int(st, 1);
    res.uConsumed = sqlite3_column_int(st, 2);
    res.uUpdated  = sqlite3_column_int64(st, 3);
    
    sqlite3_finalize(st);
    delete [] date;
    
    return res;
}

std::vector<tListItemContent>
DB::GetTodayMeals ()
{
        std::vector<tListItemContent>   res;
        sqlite3_stmt *                  st;
        char *                          date;
        const char *                    q = R"(
            SELECT tm.id, m.title, m.cals
            FROM today_meals tm
            JOIN meals m ON tm.meal_id = m.id
            WHERE tm.entry_date = ?
            ORDER BY tm.id ASC;
        )";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return {};
    }
    
    date = new char [11];
    GetTodayDate (date);
    
    sqlite3_bind_text(st, 1, date, -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        tListItemContent meal;
        
        const unsigned char * id = sqlite3_column_text(st, 0);
        const unsigned char * name = sqlite3_column_text(st, 1);
        
        meal.uId = id ? (const char *)id : "";
        meal.uTitle = name ? (const char *)name: "";
        meal.uCals = sqlite3_column_int(st, 2);
        
        res.push_back (meal);
    }
    
    sqlite3_finalize(st);
    delete[] date;
    
    return res;
}
