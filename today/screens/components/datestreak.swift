//
//  datestreak.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct Streak: View
{
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        Button {
        } label: {
            Label("\(v.streak) day streak", systemImage: "tag.fill")
                .font(.footnote)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)          
        .tint(.blue)
    }
}

struct DateAndStreak: View
{
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        HStack
        {
            VStack (alignment: .leading)
            {
                Text (v.date)
                    .font(.title3)
                Text ("Daily Deficit")
                    .font(.footnote)
            }
            
            Spacer ()
            
            Streak ()
        }
        .frame(maxWidth: .infinity)
    }
}
