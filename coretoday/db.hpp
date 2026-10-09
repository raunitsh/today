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
                                        DB                  ();
                                        ~DB                 ();
        
        bool                            Open                (const std::string& pPath);
        void                            Close               ();

        std::vector<tListItemContent>   GetMealsInv         ();
        bool                            LogMeal             (const std::string& pMealId);
        bool                            UnLogMeal           (const int pRecordId);
        bool                            AddMealInv          (const std::string& pId, const std::string& pTitle, const int& pCals, const int& pProtein, const std::string& pIcon);
        bool                            DelMealInv          (const std::string& pId);
        
        std::vector<tListItemContent>   GetExInv            ();
        bool                            LogEx               (const std::string& pActId);
        bool                            UnLogEx             (const int pRecordId);
        bool                            AddExInv            (const std::string& pId, const std::string& pTitle, const int& pCals, const std::string& pIcon);
        bool                            DelExInv            (const std::string& pId);
        
        tProfile                        GetProf             ();
        
        tToday                          GetToday            ();
        std::vector<tListItemContent>   GetTodayTimeline    ();
        std::vector<tListItemContent>   GetTodayMeals       ();
        std::vector<tListItemContent>   GetTodayEx          ();
        bool                            DelTodayMeal        (const int pId);
        bool                            DelTodayEx          (const int pId);
    
        std::vector<std::string>        GetLogHistory       ();
        
        int                             GetTotalDeficit     (const int& pDays);
        std::vector<int>                GetDeficits         (const int& pDays);
        std::vector<int>                GetProtein          (const int& pDays);
    
const   std::vector<tListItemContent> & GetMealsInvCpp      ()  const [[clang::lifetimebound]];
    
        std::vector<tListItemContent>   uMeals;
    
private:
    
    bool                            InternalMapMeal     (const char * pDate, const char * pMealId);
    bool                            InternalUnmapMeal   (const int pRecordId);
    bool                            InternalMapEx       (const char * pDate, const char * pMealId);
    bool                            InternalUnmapEx     (const int pRecordId);
    bool                            InternalExecute     (const char * pSql);
    void                            InternalCreateUser  ();
    
    struct sqlite3*                 vDb = nullptr;
};
