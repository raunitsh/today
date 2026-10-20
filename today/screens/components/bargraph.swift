//
//  bargraph.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI
import Charts

struct BarGraph: View
{
    var pData: [DayMetric]
    let pTitle: String
    let pUnit: String
    let pYAxis: String
    let pColor: AnyGradient
    
    var v = TodayViewModel.shared;
    
    @State
    var selectedDay: String?
    
    // Tracks the metric selected for the bottom sheet
    @State
    private var selectedMetricForSheet: DayMetric?
    
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
                BarMark(
                    x: .value("Day", item.day),
                    y: .value(pYAxis, item.metric)
                )
                .foregroundStyle(pColor)
                .cornerRadius(6)
                .opacity(selectedDay == nil || selectedDay == item.day ? 1.0 : 0.4)
                .annotation(position: .top, spacing: 4)
                {
                    if selectedDay == item.day
                    {
                        Text("\(item.metric) \(pUnit)")
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
                            .onTapGesture {
                                selectedDay = nil
                            }
                    }
                }
            }
            .chartGesture { proxy in
                LongPressGesture(minimumDuration: 0.35)
                    .sequenced(before: DragGesture(minimumDistance: 0))
                    .onEnded { value in
                        // Deep-tap: capture coordinate from drag and open sheet
                        if case .second(true, let drag) = value,
                           let location = drag?.location,
                           let day = proxy.value(atX: location.x, as: String.self),
                           let metric = pData.first(where: { $0.day == day }) {
                            selectedDay = nil
                            selectedMetricForSheet = metric
                            v.GetHistoryForDate (metric.date);
                        }
                    }
                    .exclusively(
                        before: SpatialTapGesture()
                            .onEnded { event in
                                // Normal tap: toggle Y-value tooltip
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
                    )
            }
            .frame(height: 250)
            .animation(.snappy(duration: 0.3), value: selectedDay)
            .sensoryFeedback(.impact(weight: .medium), trigger: selectedMetricForSheet != nil)
            .sheet(item: $selectedMetricForSheet) { metric in
                DayDetailSheet(stats: v.historyDay, timeline: v.oldTimeline, unit: pUnit)
            }
        }
        .padding()
    }

}

// MARK: - Day Detail Bottom Sheet Placeholder
struct DayDetailSheet: View
{
    let stats: Today;
    let timeline: [ListItemContent];
    
    let unit: String
    
    @Environment(\.dismiss)
    private var dismiss
    
    var date: String
    {
        stats.date.isEmpty ? "Start Logging !" :
        formatDisplayDate (from: stats.date)!
    }
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack (alignment: .leading)
                {
                    CurrentStats (stats: stats, bmr: UserViewModel.shared.userProfile!.bmr);
                    TodayTimeline (timeline: timeline, readonly: true)
                    {_ in
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.all)
            }
            .navigationTitle(date)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button("Done")
                    {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
