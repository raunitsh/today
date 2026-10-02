//
//  db.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"
#include <iostream>

DB::DB ()
    : vDb (nullptr)
{
    
}

DB::~DB ()
{
    Close ();
}

bool
DB::Open (const std::string &pPath)
{
        int rc;
        const char * schema = R"(
            CREATE TABLE IF NOT EXISTS meals (
                id TEXT PRIMARY KEY NOT NULL,
                title TEXT NOT NULL,
                cals  INTEGER NOT NULL
            );
            CREATE TABLE IF NOT EXISTS activities (
                id TEXT PRIMARY KEY NOT NULL,
                title TEXT NOT NULL,
                cals  INTEGER NOT NULL
            );
        )";
    
    rc = sqlite3_open(pPath.c_str (), &vDb);
    if (rc != SQLITE_OK)
    {
        std::cerr << "[ERR] Cannot open db" << sqlite3_errmsg (vDb) << std::endl;
        return false;
    }
    
    return InternalExecute (schema);
}

bool
DB::InternalExecute (const char *pSql)
{
        char *  err = nullptr;
        int     rc;
    
    if (!vDb)
    {
        std::cerr << "[ERR] No db" << std::endl;
        return false;
    }
    
    rc = sqlite3_exec(vDb, pSql, nullptr, nullptr, &err);
    if (rc != SQLITE_OK)
    {
        std::cerr << "[ERR] Cannot exec" << (err ? err : "Unknown") << std::endl;
        sqlite3_free (err);
        return false;
    }
    
    return true;
}

void
DB::Close ()
{
    if (vDb)
    {
        sqlite3_close (vDb);
        vDb = nullptr;
    }
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
