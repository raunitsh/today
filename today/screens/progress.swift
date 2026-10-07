//
//  progress.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI

struct ProgressScreen: View
{
    @Bindable
    var v = ProgressViewModel.shared;
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {
                    FatLoss ()
                    
                    Picker("Select duration", selection: $v.pDuration) {
                        ForEach(eProgressDuration.allCases) { type in
                            Text("\(type.rawValue)").tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    DeficitHistory ();
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
        }.navigationTitle("Progress")
    }
}
