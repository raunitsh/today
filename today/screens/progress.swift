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
                    
                    Picker("Select duration", selection: $v.uDuration) {
                        ForEach(eProgressDuration.allCases) { type in
                            Text("\(type.rawValue)").tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if v.uDuration == .WEEK
                    {
                        BarGraph (pData: v.progress.deficitHistory, pTitle: "Weekly Deficits", pUnit: "kcal", pYAxis: "Deficits", pColor: Color.blue.gradient);
                        BarGraph (pData: v.progress.proteinIntake, pTitle: "Protein Intake", pUnit: "gm", pYAxis: "Intake", pColor: Color.green.gradient);
                        BarGraph (pData: v.progress.calIntake, pTitle: "Calorie Intake", pUnit: "kcal", pYAxis: "Intake", pColor: Color.red.gradient);
                        BarGraph (pData: v.progress.activeCals, pTitle: "Active calories", pUnit: "kcal", pYAxis: "Burn", pColor: Color.yellow.gradient);
                    }
                    else
                    {
                        LineGraph (pData: v.progress.deficitHistory, pTitle: "Weekly Deficit Average", pUnit: "kcal/day", pYAxis: "Deficits", pColor: Color.blue.gradient);
                        LineGraph (pData: v.progress.proteinIntake, pTitle: "Weekly Protein Average", pUnit: "gm/day", pYAxis: "Intake", pColor: Color.green.gradient);
                        LineGraph (pData: v.progress.calIntake, pTitle: "Weekly Intake Average", pUnit: "kcal/day", pYAxis: "Intake", pColor: Color.red.gradient);
                        LineGraph (pData: v.progress.activeCals, pTitle: "Weekly Active Average", pUnit: "kcal/day", pYAxis: "Burn", pColor: Color.yellow.gradient);
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: v.uDuration)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
            .onChange(of: currTab)
            {_, newtab in
                
                if newtab == .PROGRESS
                {
                    Task { ProgressViewModel.shared.Sync () }
                }
            }
        }
        .navigationTitle("Progress")
    }
}
