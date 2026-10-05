//
//  currentstats.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct VisualProgress: View
{
    let consumed = Float (TodayViewModel.shared.today.consumed);
    let bmr = Float (UserViewModel.shared.userProfile?.bmr ?? 0);
    
    var progress: Double {
        guard bmr > 0 else { return 0.0 }
        return min (max (Double (consumed) / Double (bmr), 0.0), 1.0)
    }
    
    var body: some View
    {
        ProgressView (value: progress)
            .progressViewStyle (.linear)
            .animation (.spring (response: 0.45, dampingFraction: 0.75), value: progress)
    }
}

struct CurrentStats: View
{
    var v = TodayViewModel.shared;
    var bmr = UserViewModel.shared.userProfile?.bmr ?? 0;
    
    var body: some View
    {
        VStack (alignment: .leading)
        {
            HStack (alignment: .bottom)
            {
                Text ("\(v.today.deficit)")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .bold()
                    .contentTransition(.numericText())
                    .animation(.snappy, value: v.today.deficit)
                
                Text ("kcal")
                    .font(.footnote)
                
                Spacer ()
            }
            .frame(maxWidth: .infinity)
            .debug()
            
            HStack
            {
                Text ("BMR")

                Text ("\(bmr)")
                    .contentTransition(.numericText())
                    .animation(.snappy, value: bmr)
                
                
                Text ("Eaten")
                Text ("\(v.today.consumed)")
                    .contentTransition(.numericText())
                    .animation(.snappy, value: v.today.consumed)
            }
            .font(.caption)
            .debug()
            
            VisualProgress ()
        }
        .frame(maxWidth: .infinity)
        .debug ()
    }
}
