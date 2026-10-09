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
        const char * q = "SELECT date, deficit, consumed, protein, active, updated_at FROM today WHERE date = ?;";
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
    res.uProtein =  sqlite3_column_int(st, 3);
    res.uActive = sqlite3_column_int(st, 4);
    res.uUpdated  = sqlite3_column_int64(st, 5);
    
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
            SELECT tm.id, m.title, m.cals, m.protein, m.icon
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
        
        const unsigned char * name = sqlite3_column_text(st, 1);
        const unsigned char * icon = sqlite3_column_text(st, 4);
        
        meal.uRecordId = sqlite3_column_int(st, 0);
        meal.uTitle = name ? (const char *)name: "";
        meal.uCals = sqlite3_column_int(st, 2);
        meal.uProtein = sqlite3_column_int(st, 3);
        meal.uIcon = icon ? (const char *)icon : "";
        
        res.push_back (meal);
    }
    
    sqlite3_finalize(st);
    delete[] date;
    
    return res;
}

std::vector<tListItemContent>
DB::GetTodayEx ()
{
        std::vector<tListItemContent>   res;
        sqlite3_stmt *                  st;
        char *                          date;
        const char *                    q = R"(
            SELECT ta.id, a.title, a.cals, a.icon
            FROM today_act ta
            JOIN activities a ON ta.act_id = a.id
            WHERE ta.entry_date = ?
            ORDER BY ta.id ASC;
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
        tListItemContent act;
        
        const unsigned char * name = sqlite3_column_text(st, 1);
        const unsigned char * icon = sqlite3_column_text(st, 3);
        
        act.uRecordId = sqlite3_column_int(st, 0);
        act.uTitle = name ? (const char *)name: "";
        act.uCals = sqlite3_column_int(st, 2);
        act.uIcon = icon ? (const char *)icon : "";
        
        res.push_back (act);
    }
    
    sqlite3_finalize(st);
    delete[] date;
    
    return res;
}

bool
DB::DelTodayEx (const int pId)
{
    return true;
}

std::vector<std::string>
DB::GetLogHistory ()
{
        std::vector<std::string> res;
        const char * q = "SELECT date FROM today ORDER BY date DESC";
        sqlite3_stmt * st;
        const unsigned char * d;
    
    if (!vDb)
    {
        return res;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return res;
    }
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        d = sqlite3_column_text(st, 0);
        
        res.push_back (d ? (const char *)d : "");
    }
    
    return res;
}
