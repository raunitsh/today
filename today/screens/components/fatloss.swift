//
//  fatloss.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI

struct FatLoss: View
{
    var vm = ProgressViewModel.shared
    
    @State
    private var days: Int32 = 7;
    
    private var kgLost: Double
    {
        Double(vm.progress.totalDeficit) / 7700.0
    }
    
    var body: some View
    {
        VStack (alignment: .leading)
        {
            Text("Estimated weight loss")
            
            HStack (alignment: .firstTextBaseline, spacing: 4)
            {
                Text (kgLost, format: .number.precision(.fractionLength(2)))
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .bold()
                    .contentTransition(.numericText())
                    .animation(.snappy, value: kgLost)
                
                Text("kg")
                    .font(.body)
            }
            .foregroundStyle(.primary)
            
            HStack
            {
                Text ("\(vm.progress.totalDeficit) kcal total deficit")
                Dot()
                Menu {
                    Button("Last 7 Days  ") { days = 7 }
                    Button("Last 30 Days") { days = 30 }
                } label: {
                    Text("last \(days) days")
                        .foregroundColor(.blue)
                }
            }
            
            Divider ()
            
            Text ("Estimate at 7,700 kcal per kg. The scale will move differently day to day because of water and food weight.");
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.top)
        .onChange(of: days)
        {
            vm.UpdateTotalDeficit (days);
        }
    }
}
