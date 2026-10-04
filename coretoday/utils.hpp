//
//  utils.hpp
//  today
//
//  Created by Raunit Shrivastava on 04/10/26.
//
#pragma once

#include <ctime>

inline void
GetTodayDate (char * pBuff)
{
        std::time_t t = std::time (nullptr);

    std::strftime (pBuff, 11, "%Y-%m-%d", std::localtime(&t));
}

inline int64_t
GetNow ()
{
    return std::chrono::duration_cast<std::chrono::seconds> (std::chrono::system_clock::now().time_since_epoch()).count();
}
