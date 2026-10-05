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
        VStack
        {
            HStack
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
                    }
                    Text ("Daily deficit")
                        .font(.footnote)
                }
                
                Spacer ()
                
                VStack (alignment: .trailing)
                {
                    HStack
                    {
                        Text ("BMR")
                        Text ("\(bmr)")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: bmr)
                    }
                    
                    HStack
                    {
                        Text ("Eaten")
                        Text ("\(v.today.consumed)")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: v.today.consumed)
                    }
                    
                    HStack
                    {
                        Text ("Protein")
                        Text ("\(v.today.protein)g")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: v.today.protein)
                    }
                    
                    HStack
                    {
                        Text ("Active")
                        Text ("\(v.today.active) kcal")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: v.today.consumed)
                    }
                }
                .font(.caption)
            }
            VisualProgress ()
        }
        .frame(maxWidth: .infinity)
    }
}
