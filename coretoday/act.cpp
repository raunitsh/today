//
//  act.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"
#include "utils.hpp"

bool
DB::AddExInv(const std::string &pId, const std::string &pTitle, const int &pCals, const std::string& pIcon)
{
        const char *    q = nullptr;
        sqlite3_stmt*   st = nullptr;
        bool            rc;
    
    if (!vDb)
    {
        return false;
    }
    
    q = "INSERT OR REPLACE INTO activities (id, title, cals, icon) VALUES (?, ?, ?, ?);";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text (st, 1, pId.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text (st, 2, pTitle.c_str (), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int (st, 3, pCals);
    sqlite3_bind_text(st, 4, pIcon.c_str (), -1, SQLITE_TRANSIENT);
    
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
    
    sql = "SELECT id, title, cals, icon FROM activities WHERE del = 0;";
    
    if (sqlite3_prepare_v2(vDb, sql, -1, &st, nullptr) == SQLITE_OK)
    {
        while (sqlite3_step (st) == SQLITE_ROW)
        {
            tListItemContent act;
            
            const unsigned char * id = sqlite3_column_text(st, 0);
            const unsigned char * title = sqlite3_column_text(st, 1);
            int cals = sqlite3_column_int(st, 2);
            const unsigned char * icon = sqlite3_column_text(st, 3);
            
            act.uId = id ? (const char *)id : "";
            act.uTitle = title ? (const char *)title : "";
            act.uCals = cals;
            act.uIcon = icon ? (const char *)icon : "";
            
            res.push_back (act);
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

// find act
// find bmr
// create today's date
// find today's entry
// if found -> update entry with cals
// if not found -> insert new entry with vals
// deficit = bmr - workout
bool
DB::LogEx(const std::string &pActId)
{
        int act_cals = -1;
        int bmr = -1;
        const char * q = "SELECT cals FROM activities WHERE id = ?;";
        char * curr_date;
        int64_t created = 0;
        int64_t updated = 0;
        int deficit = 0;
        int active = 0;
        int rc;
        sqlite3_stmt * st_act;
        sqlite3_stmt * st_bmr;
        sqlite3_stmt * st_today;
        sqlite3_stmt * st_new;

    if (!vDb)
    {
        return false;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_act, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    sqlite3_bind_text(st_act, 1, pActId.c_str (), -1, SQLITE_TRANSIENT);
    
    rc = sqlite3_step(st_act);
    
    if (rc != SQLITE_ROW)
    {
        // act doesnt exist
        sqlite3_finalize(st_act);
        return false;
    }
    
    act_cals = sqlite3_column_int (st_act, 0);
    
    sqlite3_finalize(st_act);
    
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
    
    q = "SELECT deficit, active FROM today where date = ?;";
    
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
        deficit = sqlite3_column_int(st_today, 0);
        active = sqlite3_column_int(st_today, 1);
        
        sqlite3_finalize(st_today);
        
        // deficit should INCREASE
        deficit -= act_cals;
        active += act_cals;

        q = "UPDATE today SET deficit = ?, updated_at = ?, active = ? WHERE date = ?;";
        
        if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
        {
            delete[] curr_date;
            return false;
        }
        
        updated = GetNow ();

        sqlite3_bind_int(st_new, 1, deficit);
        sqlite3_bind_int64(st_new, 2, updated);
        sqlite3_bind_int(st_new, 3, active);
        sqlite3_bind_text(st_new, 4, curr_date, -1, SQLITE_TRANSIENT);
        
        rc = (sqlite3_step(st_new) == SQLITE_DONE);
        
        sqlite3_finalize(st_new);
        
        if (rc)
        {
            rc = InternalMapEx (curr_date, pActId.c_str ());
        }
        
        delete[] curr_date;
        return rc;
    }
    else if (rc == SQLITE_DONE)
    {
        // No existing record for today
        sqlite3_finalize(st_today);
        
        q = "INSERT INTO today (date, deficit, active, created_at, updated_at) VALUES (?, ?, ?, ?, ?);";
        
        if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
        {
            delete[] curr_date;
            return false;
        }
        
        deficit = act_cals;
        active += act_cals;
        created = GetNow();
        updated = GetNow();
        
        sqlite3_bind_text(st_new, 1, curr_date, -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(st_new, 2, deficit);
        sqlite3_bind_int(st_new, 3, active);
        sqlite3_bind_int64(st_new, 4, created);
        sqlite3_bind_int64(st_new, 5, updated);
        
        rc = (sqlite3_step(st_new) == SQLITE_DONE);
        sqlite3_finalize(st_new);
        
        if (rc)
        {
            rc = InternalMapEx (curr_date, pActId.c_str ());
        }
        
        delete[] curr_date;
        return rc;
    }
    
    // Err
    delete[] curr_date;
    sqlite3_finalize(st_today);
    return false;
}

bool
DB::UnLogEx (const int pRecordId)
{
        int act_cals = -1;
        char * curr_date;
        int64_t updated = 0;
        int deficit = 0;
        int active = 0;
        int rc;
        sqlite3_stmt * st_rec;
        sqlite3_stmt * st_today;
        sqlite3_stmt * st_new;
    
        const char * q = R"(
            SELECT a.cals
            FROM today_act ta
            JOIN activities a ON ta.act_id = a.id
            WHERE ta.id = ?
            ORDER BY ta.id ASC;
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
    
    act_cals = sqlite3_column_int (st_rec, 0);
    
    sqlite3_finalize(st_rec);
    
    curr_date = new char [11];
    GetTodayDate (curr_date);
    
    q = "SELECT deficit, active FROM today where date = ?;";
    
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
    deficit = sqlite3_column_int(st_today, 0);
    active = sqlite3_column_int(st_today, 1);
    
    sqlite3_finalize(st_today);
    
    deficit += act_cals;
    active -= act_cals;

    q = "UPDATE today SET deficit = ?, active = ?, updated_at = ? WHERE date = ?;";
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st_new, nullptr) != SQLITE_OK)
    {
        delete[] curr_date;
        return false;
    }
    
    updated = GetNow ();

    sqlite3_bind_int(st_new, 1, deficit);
    sqlite3_bind_int(st_new, 2, active);
    sqlite3_bind_int64(st_new, 3, updated);
    sqlite3_bind_text(st_new, 4, curr_date, -1, SQLITE_TRANSIENT);
    
    rc = (sqlite3_step(st_new) == SQLITE_DONE);
    
    sqlite3_finalize(st_new);
    
    if (rc)
    {
        rc = InternalUnmapEx (pRecordId);
    }
    
    delete[] curr_date;
    return rc;
}

bool
DB::InternalUnmapEx (const int pId)
{
    const char * q = "DELETE FROM today_act WHERE id = ?;";
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


bool
DB::InternalMapEx (const char *pDate, const char *pActId)
{
        const char * q = "INSERT INTO today_act (entry_date, act_id, created_at) VALUES (?, ?, ?);";
        sqlite3_stmt* st;
        bool rc;
        int64_t now;
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return false;
    }
    
    now = GetNow ();
    
    sqlite3_bind_text(st, 1, pDate, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(st, 2, pActId, -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(st, 3, now);
    
    rc = (sqlite3_step(st) == SQLITE_DONE);
    
    sqlite3_finalize(st);
    
    return rc;
}

