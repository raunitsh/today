//
//  datestreak.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct Streak: View
{
    var body: some View
    {
        Button {
        } label: {
            Label("12 day streak", systemImage: "tag.fill")
                .font(.footnote)
        }
        .buttonStyle(.bordered)               // Gives it a pill background
        .buttonBorderShape(.capsule)          // Makes it a rounded capsule
        .tint(.blue)
    }
}

struct DateAndStreak: View
{
    var body: some View
    {
        HStack
        {
            VStack (alignment: .leading)
            {
                Text ("Fri 2 Oct")
                    .font(.title3)
                Text ("Daily Deficit")
                    .font(.footnote)
            }
            .debug()
            
            Spacer ()
            
            Streak ()
        }
        .frame(maxWidth: .infinity)
        .debug()
    }
}
