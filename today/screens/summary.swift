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
        VStack (alignment: .leading)
        {
            DateAndStreak ();
            CurrentStats ();
            EatenToday ();
            ActivityToday ();
        }
        .padding(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
