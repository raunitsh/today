//
//  deficithistory.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI
import Charts

struct DeficitHistory: View
{
    let history: [DaynDeficit] = ProgressViewModel.shared.progress.deficitHistory
    
    @State private var selectedDay: String? = nil
    
    private var selectedItem: DaynDeficit? {
        history.first { $0.day == selectedDay }
    }
    
    var body: some View
    {
        VStack (alignment: .leading, spacing: 12)
        {
            HStack
            {
                Text("Weekly Deficits")
                    .font(.headline)
                
                Spacer()
                
                if let selected = selectedItem {
                    Text("\(selected.day): \(selected.deficit, specifier: "%.0f")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Chart(history)
            { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Deficit", item.deficit)
                )
                .foregroundStyle(Color.blue.gradient)
                .cornerRadius(6)
                .opacity(selectedDay == nil || selectedDay == item.day ? 1.0 : 0.4)
                .annotation(position: .top, spacing: 4)
                {
                    if selectedDay == item.day
                    {
                        Text("\(item.deficit, specifier: "%.0f")")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .shadow(radius: 2)
                    }
                }
            }
            .chartXSelection(value: $selectedDay)
            .frame(height: 250)
        }
        .padding()
    }
}
