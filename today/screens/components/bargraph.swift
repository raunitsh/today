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
    
    @State
    var selectedDay: String?;
    
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
                .opacity(selectedDay == nil || selectedDay == item.day ? 1.0 : 0.4)
                .annotation(position: .top, spacing: 4)
                {
                    if selectedDay == item.day
                    {
                        Text("\(item.metric)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                            .transition(.opacity.combined(with: .scale(scale: 0.85)))
                    }
                }
            }
            .chartXSelection(value: $selectedDay)
            .frame(height: 250)
            .animation(.snappy(duration: 0.3), value: selectedDay)
        }
        .padding()
    }
}
