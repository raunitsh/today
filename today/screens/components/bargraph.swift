//
//  deficithistory.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI
import Charts

struct BarGraph: View
{
    var pData: [DayMetric];
    let pTitle: String;
    let pYAxis: String;
    
    let history: [DayMetric] = ProgressViewModel.shared.progress.deficitHistory
    
    var body: some View
    {
        VStack (alignment: .leading, spacing: 12)
        {
            Text(pTitle)
                .font(.headline)
            
            Chart(pData)
            { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value(pYAxis, item.metric)
                )
                .foregroundStyle(Color.blue.gradient)
                .cornerRadius(6)
            }
            .frame(height: 250)
        }
        .padding()
    }
}
