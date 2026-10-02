//
//  db.hpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#pragma once

#include "datatypes.hpp"

#include <sqlite3.h>
#include <vector>

class DB {
    
public:
                                    DB              ();
                                    ~DB             ();
    
    bool                            Open            (const std::string& pPath);
    void                            Close           ();
    
    bool                            AddMealInv      (const std::string& pId, const std::string& pTitle, const int& pCals);
    std::vector<tListItemContent>   GetMealsInv     ();
    
    bool                            AddExInv        (const std::string& pId, const std::string& pTitle, const int& pCals);
    std::vector<tListItemContent>   GetExInv        ();
    
private:
    
    bool                            InternalExecute (const char * pSql);
    
    struct sqlite3*                 vDb = nullptr;
};
