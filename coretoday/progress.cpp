//
//  progress.cpp
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

#include "db.hpp"

int
DB::GetTotalDeficit (const int &pDays)
{
        sqlite3_stmt *  st;
        int             offset  = -(pDays - 1);
        int             total   = 0;
        const char *    q       = R"(
            SELECT COALESCE(SUM(deficit), 0), date
            FROM today 
            WHERE date >= date('now', 'localtime', ? || ' days')
            AND date <= date('now', 'localtime');
        )";
    
    if (!vDb)
    {
        return 0;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return 0;
    }
    
    sqlite3_bind_int(st, 1, offset);
    
    if (sqlite3_step(st) != SQLITE_ROW)
    {
        sqlite3_finalize(st);
        return 0;
    }
    
    total = sqlite3_column_int(st, 0);
    
    sqlite3_finalize(st);
    
    return total;
}

std::vector<std::pair<std::string, int>>
DB::GetDeficits (const int &pDays)
{
        std::vector<std::pair<std::string, int>>     res;
        sqlite3_stmt *                              st;
        int                                         offset = -(pDays - 1);
        const char *                                q = R"(
            WITH RECURSIVE last_n_days(dt) AS (
                VALUES(date('now', 'localtime', ? || ' days'))
                UNION ALL
                SELECT date(dt, '+1 day') from last_n_days
                WHERE dt < date('now', 'localtime')
            )
            SELECT d.dt, COALESCE(t.deficit, 0) AS deficit
            FROM    last_n_days d
            LEFT JOIN today t ON d.dt = t.date
            ORDER BY d.dt ASC;
        )";
    
    if (pDays <= 0 || !vDb)
    {
        return res;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return res;
    }
    
    sqlite3_bind_int(st, 1, offset);
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        const unsigned char * d = sqlite3_column_text(st, 0);
        std::pair<std::string, int> p;
        
        p.first = (const char *)d;
        p.second = sqlite3_column_int(st, 1);
        
        res.push_back(p);
    }
    
    sqlite3_finalize(st);
    
    return res;
}

std::vector<std::pair<std::string, int>>
DB::GetCalIntake (const int &pDays)
{
        std::vector<std::pair<std::string, int>>     res;
        sqlite3_stmt *                              st;
        int                                         offset = -(pDays - 1);
        const char *                                q = R"(
            WITH RECURSIVE last_n_days(dt) AS (
                VALUES(date('now', 'localtime', ? || ' days'))
                UNION ALL
                SELECT date(dt, '+1 day') from last_n_days
                WHERE dt < date('now', 'localtime')
            )
            SELECT d.dt, COALESCE(t.consumed, 0) AS deficit
            FROM    last_n_days d
            LEFT JOIN today t ON d.dt = t.date
            ORDER BY d.dt ASC;
        )";
    
    if (pDays <= 0 || !vDb)
    {
        return res;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return res;
    }
    
    sqlite3_bind_int(st, 1, offset);
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        const unsigned char * d = sqlite3_column_text(st, 0);
        std::pair<std::string, int> p;
        
        p.first = (const char *)d;
        p.second = sqlite3_column_int(st, 1);
        
        res.push_back(p);
    }
    
    sqlite3_finalize(st);
    
    return res;
}

std::vector<tToday>
DB::GetProgress (const int &pDays)
{
        std::vector<tToday>     res;
        sqlite3_stmt *          st;
        int                     offset = -(pDays - 1);
        const char *            q = R"(
            WITH RECURSIVE last_n_days(dt) AS (
                VALUES(date('now', 'localtime', ? || ' days'))
                UNION ALL
                SELECT date(dt, '+1 day') from last_n_days
                WHERE dt < date('now', 'localtime')
            )
            SELECT d.dt, COALESCE(t.deficit, 0) AS deficit, COALESCE(t.consumed, 0) AS consumed, COALESCE(t.active, 0) AS active, COALESCE(t.protein, 0) AS protein
            FROM    last_n_days d
            LEFT JOIN today t ON d.dt = t.date
            ORDER BY d.dt ASC;
        )";
    
    if (pDays <= 0 || !vDb)
    {
        return res;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return res;
    }
    
    sqlite3_bind_int(st, 1, offset);
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        const unsigned char * d = sqlite3_column_text(st, 0);
        tToday t;
        
        t.uDate = (const char *)d;
        t.uDeficit = sqlite3_column_int(st, 1);
        t.uConsumed = sqlite3_column_int(st, 2);
        t.uActive = sqlite3_column_int(st, 3);
        t.uProtein = sqlite3_column_int(st, 4);
        
        res.push_back(t);
    }
    
    sqlite3_finalize(st);
    
    return res;
}


std::vector<int>
DB::GetProtein (const int &pDays)
{
        std::vector<int>    res;
        sqlite3_stmt *      st;
        int                 offset = -(pDays - 1);
        const char *        q = R"(
            WITH RECURSIVE last_n_days(dt) AS (
                VALUES(date('now', 'localtime', ? || ' days'))
                UNION ALL
                SELECT date(dt, '+1 day') from last_n_days
                WHERE dt < date('now', 'localtime')
            )
            SELECT COALESCE(t.protein, 0) AS protein
            FROM    last_n_days d
            LEFT JOIN today t ON d.dt = t.date
            ORDER BY d.dt ASC;
        )";
    
    if (pDays <= 0 || !vDb)
    {
        return res;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return res;
    }
    
    sqlite3_bind_int(st, 1, offset);
    
    while (sqlite3_step(st) == SQLITE_ROW)
    {
        res.push_back (sqlite3_column_int(st, 0));
    }
    
    sqlite3_finalize(st);
    
    return res;
}
