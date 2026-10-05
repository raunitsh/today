//
//  meals.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"
#include "utils.hpp"

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
    
    sql = "SELECT id, title, cals, protein, icon FROM meals WHERE del = 0;";
    
    if (sqlite3_prepare_v2(vDb, sql, -1, &st, nullptr) == SQLITE_OK)
    {
        while (sqlite3_step (st) == SQLITE_ROW)
        {
            tListItemContent meal;
            
            const unsigned char * id = sqlite3_column_text(st, 0);
            const unsigned char * title = sqlite3_column_text(st, 1);
            int cals = sqlite3_column_int(st, 2);
            const unsigned char * icon = sqlite3_column_text(st, 4);
            
            meal.uId = id ? (const char *)id : "";
            meal.uTitle = title ? (const char *)title : "";
            meal.uCals = cals;
            meal.uProtein = sqlite3_column_int(st, 3);
            meal.uIcon = icon ? (const char *)icon: "";
            
            res.push_back (meal);
        }
        sqlite3_finalize(st);
    }
    
    return res;
}

bool
DB::AddMealInv(const std::string &pId, const std::string &pTitle, const int &pCals, const int& pProtein, const std::string& pIcon)
{
        const char *    q = nullptr;
        sqlite3_stmt*   st = nullptr;
        bool            rc;
    
    if (!vDb)
    {
        return false;
    }
    
    q = "INSERT OR REPLACE INTO meals (id, title, cals, protein, icon) VALUES (?, ?, ?, ?, ?);";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text (st, 1, pId.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text (st, 2, pTitle.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int (st, 3, pCals);
    sqlite3_bind_int(st, 4, pProtein);
    sqlite3_bind_text(st, 5, pIcon.c_str (), -1, SQLITE_TRANSIENT);
    
    rc = (sqlite3_step (st) == SQLITE_DONE);
    sqlite3_finalize(st);
    
    return rc;
}

// find meal
// find bmr
// create today's date
// find today's entry
// if found -> update entry with cals
// if not found -> insert new entry with vals
// deficit = consumed - bmr
bool
DB::LogMeal (const std::string& pMealId)
{
        int meal_cals = -1;
        int meal_protein = 0;
        int bmr = -1;
        const char * q = "SELECT cals, protein FROM meals WHERE id = ?;";
        char * curr_date;
        int64_t created = 0;
        int64_t updated = 0;
        int consumed = 0;
        int deficit = 0;
        int protein_today = 0;
        int rc;
        sqlite3_stmt * st_meal;
        sqlite3_stmt * st_bmr;
        sqlite3_stmt * st_today;
        sqlite3_stmt * st_new;

    if (!vDb)
    {
        return false;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_meal, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text(st_meal, 1, pMealId.c_str (), -1, SQLITE_TRANSIENT);
    
    rc = sqlite3_step(st_meal);
    
    if (rc != SQLITE_ROW)
    {
        // Meal doesnt exist
        sqlite3_finalize(st_meal);
        return false;
    }
    
    meal_cals = sqlite3_column_int (st_meal, 0);
    meal_protein = sqlite3_column_int(st_meal, 1);
    
    sqlite3_finalize(st_meal);
    
    q = "SELECT bmr FROM profile WHERE id = 1;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_bmr, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    rc = sqlite3_step(st_bmr);
    
    if (rc != SQLITE_ROW)
    {
        // BMR not found
        sqlite3_finalize(st_bmr);
        return false;
    }

    bmr = sqlite3_column_int (st_bmr, 0);

    sqlite3_finalize (st_bmr);
    
    curr_date = new char [11];
    GetTodayDate (curr_date);
    
    q = "SELECT consumed, deficit, protein FROM today where date = ?;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_today, nullptr) != SQLITE_OK)
    {
        delete[] curr_date;
        return false;
    }
    
    sqlite3_bind_text(st_today, 1, curr_date, -1, SQLITE_TRANSIENT);
    
    rc = sqlite3_step (st_today);
    
    if (rc == SQLITE_ROW)
    {
        // Record exists
        consumed = sqlite3_column_int(st_today, 0);
        deficit = sqlite3_column_int(st_today, 1);
        protein_today = sqlite3_column_int(st_today, 2);
        
        sqlite3_finalize(st_today);
        
        consumed += meal_cals;
        deficit += meal_cals;
        protein_today += meal_protein;

        q = "UPDATE today SET consumed = ?, deficit = ?, protein = ?, updated_at = ? WHERE date = ?;";
        
        if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
        {
            delete[] curr_date;
            return false;
        }
        
        updated = GetNow ();

        sqlite3_bind_int(st_new, 1, consumed);
        sqlite3_bind_int(st_new, 2, deficit);
        sqlite3_bind_int(st_new, 3, protein_today);
        sqlite3_bind_int64(st_new, 4, updated);
        sqlite3_bind_text(st_new, 5, curr_date, -1, SQLITE_TRANSIENT);
        
        rc = (sqlite3_step(st_new) == SQLITE_DONE);
        
        sqlite3_finalize(st_new);
        
        if (rc)
        {
            rc = InternalMapMeal (curr_date, pMealId.c_str());
        }
        
        delete[] curr_date;
        return rc;
    }
    else if (rc == SQLITE_DONE)
    {
        // No existing record for today
        sqlite3_finalize(st_today);
        
        q = "INSERT INTO today (date, consumed, deficit, protein, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?);";
        
        if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
        {
            delete[] curr_date;
            return false;
        }
        
        consumed += meal_cals;
        protein_today += meal_protein;
        deficit = consumed - bmr;
        created = GetNow();
        updated = GetNow();
        
        sqlite3_bind_text(st_new, 1, curr_date, -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(st_new, 2, consumed);
        sqlite3_bind_int(st_new, 3, deficit);
        sqlite3_bind_int(st_new, 4, protein_today);
        sqlite3_bind_int64(st_new, 5, created);
        sqlite3_bind_int64(st_new, 6, updated);
        
        rc = (sqlite3_step(st_new) == SQLITE_DONE);
        sqlite3_finalize(st_new);
        
        if (rc)
        {
            rc = InternalMapMeal (curr_date, pMealId.c_str ());
        }
        
        delete[] curr_date;
        return rc;
    }
    
    // Err
    delete[] curr_date;
    sqlite3_finalize(st_today);
    return false;
}

// update today
// remove record
bool
DB::UnLogMeal (const int pRecordId)
{
        int meal_cals = -1;
        int meal_protein = 0;
        char * curr_date;
        int64_t updated = 0;
        int consumed = 0;
        int deficit = 0;
        int protein_today = 0;
        int rc;
        sqlite3_stmt * st_rec;
        sqlite3_stmt * st_today;
        sqlite3_stmt * st_new;
    
        const char * q = R"(
            SELECT m.cals, m.protein
            FROM today_meals tm
            JOIN meals m ON tm.meal_id = m.id
            WHERE tm.id = ?
            ORDER BY tm.id ASC;
        )";

    if (!vDb)
    {
        return false;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_rec, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_int(st_rec, 1, pRecordId);
    
    rc = sqlite3_step(st_rec);
    
    if (rc != SQLITE_ROW)
    {
        // No record
        sqlite3_finalize(st_rec);
        return false;
    }
    
    meal_cals = sqlite3_column_int (st_rec, 0);
    meal_protein = sqlite3_column_int(st_rec, 1);
    
    sqlite3_finalize(st_rec);
    
    curr_date = new char [11];
    GetTodayDate (curr_date);
    
    q = "SELECT consumed, deficit, protein FROM today where date = ?;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_today, nullptr) != SQLITE_OK)
    {
        delete[] curr_date;
        return false;
    }
    
    sqlite3_bind_text(st_today, 1, curr_date, -1, SQLITE_TRANSIENT);
    
    rc = sqlite3_step (st_today);
    
    if (rc != SQLITE_ROW)
    {
        // No log record
        delete[] curr_date;
        sqlite3_finalize(st_today);
        return false;
    }
    
    // Record exists
    consumed = sqlite3_column_int(st_today, 0);
    deficit = sqlite3_column_int(st_today, 1);
    protein_today = sqlite3_column_int(st_today, 2);
    
    sqlite3_finalize(st_today);
    
    consumed -= meal_cals;
    deficit -= meal_cals;
    protein_today -= meal_protein;

    q = "UPDATE today SET consumed = ?, deficit = ?, protein = ?, updated_at = ? WHERE date = ?;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
    {
        delete[] curr_date;
        return false;
    }
    
    updated = GetNow ();

    sqlite3_bind_int(st_new, 1, consumed);
    sqlite3_bind_int(st_new, 2, deficit);
    sqlite3_bind_int(st_new, 3, protein_today);
    sqlite3_bind_int64(st_new, 4, updated);
    sqlite3_bind_text(st_new, 5, curr_date, -1, SQLITE_TRANSIENT);
    
    rc = (sqlite3_step(st_new) == SQLITE_DONE);
    
    sqlite3_finalize(st_new);
    
    if (rc)
    {
        rc = InternalUnmapMeal (pRecordId);
    }
    
    delete[] curr_date;
    return rc;
}


bool
DB::InternalMapMeal(const char *pDate, const char *pMealId)
{
        const char * q = "INSERT INTO today_meals (entry_date, meal_id, created_at) VALUES (?, ?, ?);";
        sqlite3_stmt* st;
        bool rc;
        int64_t now;
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    now = GetNow ();
    
    sqlite3_bind_text(st, 1, pDate, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(st, 2, pMealId, -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(st, 3, now);
    
    rc = (sqlite3_step(st) == SQLITE_DONE);
    
    sqlite3_finalize(st);
    
    return rc;
}

bool
DB::InternalUnmapMeal (const int pId)
{
    const char * q = "DELETE FROM today_meals WHERE id = ?;";
    sqlite3_stmt * st;
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_int(st, 1, pId);
    
    if (sqlite3_step(st) != SQLITE_DONE)
    {
        sqlite3_finalize(st);
        return false;
    }
    
    sqlite3_finalize(st);
    return true;
}
