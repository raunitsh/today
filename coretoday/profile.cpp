//
//  profile.cpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include "db.hpp"
#include <iostream>

tProfile
DB::GetProf ()
{
        tProfile    res;
        const char * q = "SELECT name, age, height, weight, bmr FROM profile WHERE id = 1;";
        sqlite3_stmt* st;
    
    if (!vDb)
    {
        return {};
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) == SQLITE_OK)
    {
        while (sqlite3_step(st) == SQLITE_ROW)
        {
            const unsigned char * name = sqlite3_column_text(st, 0);
            
            res.uName = name ? (const char *)name : "";
            res.uAge = sqlite3_column_int(st, 1);
            res.uHeight = sqlite3_column_int(st, 2);
            res.uWeight = sqlite3_column_int(st, 3);
            res.uBmr = sqlite3_column_int (st, 4);
        }
    }
    
    sqlite3_finalize (st);
    return res;
}

void
DB::InternalCreateUser()
{
        const char *    name = "Raunit";
        int             weight = 84;
        int             height = 188;
        int             age = 24;
        int             bmr = 0;
        sqlite3_stmt *  st = nullptr;
        const char *    q =
        "INSERT INTO profile (id, name, age, weight, height, bmr, updated_at) "
        "VALUES (1, ?, ?, ?, ?, ?, ?) "
        "ON CONFLICT(id) DO UPDATE SET "
        "   name = excluded.name, "
        "   age = excluded.age, "
        "   weight = excluded.weight, "
        "   height = excluded.height, "
        "   bmr = excluded.bmr, "
        "   updated_at = excluded.updated_at;";
      
    bmr = (int)((10 * weight) + (6.25 * height) - (5 * age) + 5);
    
    if (!vDb)
    {
        return;
    }
    
    if (sqlite3_prepare_v2(vDb, q, -1, &st, nullptr) != SQLITE_OK)
    {
        return;
    }

    int64_t now = std::chrono::duration_cast<std::chrono::seconds> (std::chrono::system_clock::now().time_since_epoch()).count();

    sqlite3_bind_text  (st, 1, name, -1, SQLITE_TRANSIENT);
    sqlite3_bind_int (st, 2, age);
    sqlite3_bind_int (st, 3, weight);
    sqlite3_bind_int (st, 4, height);
    sqlite3_bind_int (st, 5, bmr);
    sqlite3_bind_int64 (st, 6, now);
    
    if (sqlite3_step(st) == SQLITE_DONE)
    {
        std::cout << "Profile created" << std::endl;
    }
    
    sqlite3_finalize(st);
}
