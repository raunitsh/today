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
                id      TEXT    PRIMARY KEY NOT NULL,
                title   TEXT                NOT NULL,
                cals    INTEGER             NOT NULL,
                protein INTEGER             NOT NULL,
                icon    TEXT                NOT NULL,
                del     INTEGER             NOT NULL DEFAULT 0
            );
            CREATE TABLE IF NOT EXISTS activities (
                id      TEXT    PRIMARY KEY NOT NULL,
                title   TEXT                NOT NULL,
                cals    INTEGER             NOT NULL,
                icon    TEXT                NOT NULL,
                del     INTEGER             NOT NULL DEFAULT 0
            );
            CREATE TABLE IF NOT EXISTS profile (
                id      INTEGER PRIMARY KEY CHECK (id = 1),
                name    TEXT                NOT NULL,
                age     INTEGER             NOT NULL,
                weight  INTEGER             NOT NULL,
                height  INTEGER             NOT NULL,
                bmr     INTEGER             NOT NULL,
                updated_at  INTEGER         NOT NULL
            );
            CREATE TABLE IF NOT EXISTS  today (
                date        TEXT    PRIMARY KEY,
                consumed    INTEGER NOT NULL    DEFAULT 0,
                protein     INTEGER NOT NULL    DEFAULT 0,
                active      INTEGER NOT NULL    DEFAULT 0,
                deficit     INTEGER NOT NULL    DEFAULT 0,
                created_at  INTEGER NOT NULL,
                updated_at  INTEGER NOT NULL
            );
            CREATE TABLE IF NOT EXISTS today_meals (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                entry_date  TEXT    NOT NULL,
                meal_id     TEXT    NOT NULL,
                created_at  INTEGER NOT NULL,
                
                FOREIGN KEY (entry_date) REFERENCES today(date) ON DELETE CASCADE,
                FOREIGN KEY (meal_id)   REFERENCES  meals(id)   ON DELETE RESTRICT
            );
            CREATE TABLE IF NOT EXISTS today_act (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                entry_date  TEXT    NOT NULL,
                act_id      TEXT    NOT NULL,
                created_at  INTEGER NOT NULL,
                
                FOREIGN KEY (entry_date) REFERENCES today(date)     ON DELETE CASCADE,
                FOREIGN KEY (act_id)   REFERENCES  activities(id)   ON DELETE RESTRICT
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
    
    InternalCreateUser ();
    
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
