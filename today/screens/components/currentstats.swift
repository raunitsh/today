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
//            .clipShape(.capsule)
    }
}

struct CurrentStats: View
{
    var body: some View
    {
        VStack (alignment: .leading)
        {
            HStack (alignment: .bottom)
            {
                Text ("-1,040")
                    .font(.title)
                    .bold()
                Text ("kcal")
                    .font(.footnote)
                Spacer ()
            }
            .frame(maxWidth: .infinity)
            .debug()
            
            HStack
            {
                Text ("Burn")
                Text ("2,190")
                Text ("Eaten")
                Text ("1,150")
            }
            .font(.footnote)
            .debug()
            
            VisualProgress ()
        }
        .frame(maxWidth: .infinity)
        .debug ()
    }
}
