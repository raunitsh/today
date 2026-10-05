//
//  datatypes.hpp
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

#include <string>

struct tListItemContent
{
    int         uCals;
    int         uRecordId = 0;
    std::string uId;
    std::string uTitle;
    std::string uIcon;
};

struct tProfile
{
    std::string uName;
    int         uId;
    int         uAge;
    int         uWeight;
    int         uHeight;
    int         uBmr;
};

struct tToday
{
    std::string uDate;
    int         uDeficit;
    int         uConsumed;
    int         uActive;
    int64_t     uUpdated;
};
