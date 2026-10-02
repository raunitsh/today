//
//  summary.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct SummaryScreen: View
{
    var body: some View
    {
        ScrollView
        {
            VStack (alignment: .leading)
            {
                DateAndStreak ();
                CurrentStats ();
                EatenToday ();
                ActivityToday ();
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.all)
        }
    }
}
