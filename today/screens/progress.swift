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
    
    @Binding
    var currTab: eTab;
    
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
                    
                    BarGraph (pData: v.progress.deficitHistory, pTitle: "Weekly Deficits", pUnit: "kcal", pYAxis: "Deficits", pColor: Color.blue.gradient);
                    BarGraph (pData: v.progress.proteinIntake, pTitle: "Protein Intake", pUnit: "gm", pYAxis: "Intake", pColor: Color.green.gradient);
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
            .onChange(of: currTab)
            {_, newtab in
                
                if newtab == currTab
                {
                    Task { ProgressViewModel.shared.Sync () }
                }
            }
        }
        .navigationTitle("Progress")
    }
}
