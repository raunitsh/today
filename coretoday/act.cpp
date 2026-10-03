//
//  act.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"

bool
DB::AddExInv(const std::string &pId, const std::string &pTitle, const int &pCals)
{
        const char *    q = nullptr;
        sqlite3_stmt*   st = nullptr;
        bool            rc;
    
    if (!vDb)
    {
        return false;
    }
    
    q = "INSERT OR REPLACE INTO activities (id, title, cals) VALUES (?, ?, ?);";
    
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

std::vector<tListItemContent>
DB::GetExInv ()
{
        std::vector<tListItemContent>   res;
        const char *                    sql = nullptr;
        sqlite3_stmt*                   st = nullptr;
    
    if (!vDb)
    {
        return res;
    }
    
    sql = "SELECT id, title, cals FROM activities WHERE del = 0;";
    
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
DB::DelExInv (const std::string &pId)
{
        const char *    q = "UPDATE activities SET del = 1 WHERE id = ?;";
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
