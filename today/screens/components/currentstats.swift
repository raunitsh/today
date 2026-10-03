//
//  currentstats.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct VisualProgress: View
{
    var progress: Float = 1.0;
    
    var body: some View
    {
        ProgressView (value: progress)
            .progressViewStyle(.linear)
            .tint(.green)
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
                Text ("\(v.deficit)")
                    .font(.largeTitle)
                    .bold()
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
                Text ("Eaten")
                Text ("\(v.eaten)")
            }
            .font(.footnote)
            .debug()
            
            VisualProgress ()
        }
        .frame(maxWidth: .infinity)
        .debug ()
    }
}
