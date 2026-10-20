//
//  linegraph.swift
//  today
//
//  Created by Raunit Shrivastava on 21/10/26.
//

import SwiftUI
import Charts

struct LineGraph: View
{
    var pData: [DayMetric]
    let pTitle: String
    let pUnit: String
    let pYAxis: String
    let pColor: AnyGradient
    
    var v = TodayViewModel.shared;
    
    @State
    var selectedDay: String?
    
    var body: some View
    {
        VStack (alignment: .leading, spacing: 12)
        {
            HStack (alignment: .firstTextBaseline)
            {
                Text(pTitle)
                    .font(.headline)
                
                Text(pUnit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Chart(pData)
            { item in
                // Area gradient under the line
                AreaMark(
                    x: .value("Week", item.day),
                    y: .value(pYAxis, item.metric)
                )
                .foregroundStyle(pColor)
                .opacity(0.15)
                .interpolationMethod(.catmullRom)
                
                // Main trend line
                LineMark(
                    x: .value("Week", item.day),
                    y: .value(pYAxis, item.metric)
                )
                .foregroundStyle(pColor)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                // Show point markers on each week
                PointMark(
                    x: .value("Week", item.day),
                    y: .value(pYAxis, item.metric)
                )
                .foregroundStyle(pColor)
                .symbolSize(selectedDay == item.day ? 72 : 36)
                .opacity(selectedDay == nil || selectedDay == item.day ? 1.0 : 0.5)
                .annotation(position: .top, spacing: 6)
                {
                    if selectedDay == item.day
                    {
                        VStack(spacing: 2)
                        {
                            if !item.date.isEmpty
                            {
                                Text(item.date)
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text("\(item.metric) \(pUnit)")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                        .transition(.opacity.combined(with: .scale(scale: 0.85)))
                        .onTapGesture {
                            selectedDay = nil
                        }
                    }
                }
                
                // Vertical guide rule when scrubbing
                if selectedDay == item.day
                {
                    RuleMark(x: .value("Week", item.day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }
            }
            .chartXAxis {
                AxisMarks(values: pData.map(\.day)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartGesture { proxy in
                SpatialTapGesture()
                    .onEnded { event in
                        if let day = proxy.value(atX: event.location.x, as: String.self) {
                            if selectedDay == day {
                                selectedDay = nil
                            } else {
                                selectedDay = day
                            }
                        } else {
                            selectedDay = nil
                        }
                    }
                    .simultaneously(
                        with: DragGesture(minimumDistance: 0)
                            .onChanged { event in
                                if let day = proxy.value(atX: event.location.x, as: String.self) {
                                    selectedDay = day
                                }
                            }
                    )
            }
            .frame(height: 250)
            .animation(.snappy(duration: 0.3), value: selectedDay)
            .sensoryFeedback(.selection, trigger: selectedDay)
        }
        .padding()
    }
}
