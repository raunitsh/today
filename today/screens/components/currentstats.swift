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
    let stats: Today;
    let bmr: Int32;
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                VStack (alignment: .leading)
                {
                    Text ("Daily deficit")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    HStack (alignment: .firstTextBaseline, spacing: 4)
                    {
                        Text ("\(stats.deficit)")
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .bold()
                            .contentTransition(.numericText())
                            .animation(.snappy, value: stats.deficit)
                        
                        Text ("kcal")
                            .font(.body)
                    }
                }
                
                Spacer ()
                
                VStack (alignment: .trailing)
                {
                    HStack
                    {
                        Text ("Protein")
                        Text ("\(stats.protein)g")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: stats.protein)
                    }
                    
                    HStack
                    {
                        Text ("Active")
                        Text ("\(stats.active)kcal")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: stats.consumed)
                    }
                    
                    HStack
                    {
                        Text ("Eaten")
                        Text ("\(stats.consumed)kcal")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: stats.consumed)
                    }
                    
                    HStack
                    {
                        Text ("BMR")
                        Text ("\(bmr)kcal")
                            .contentTransition(.numericText())
                            .animation(.snappy, value: bmr)
                    }
                }
                .font(.caption2)
                .fontDesign(.monospaced)
            }
            VisualProgress ()
        }
        .frame(maxWidth: .infinity)
    }
}
