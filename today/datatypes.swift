//
//  datatypes.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct DayMetric: Sendable, Identifiable
{
    let id = UUID ();
    let day: String;
    let date: String;
    let metric: Int32;
    let lineXAxis: Int;
    
    nonisolated init(day: String, metric: Int32, lineXAxis: Int, date: String)
    {
        self.day = day
        self.metric = metric
        self.lineXAxis = lineXAxis;
        self.date = date;
    }
}

struct Progress: Sendable
{
    var totalDeficit: Int32;
    var deficitHistory: [DayMetric];
    var proteinIntake: [DayMetric];
    var calIntake: [DayMetric];
    var activeCals: [DayMetric];
    
    nonisolated init(totalDeficit: Int32)
    {
        self.totalDeficit = totalDeficit
        self.deficitHistory = [];
        self.proteinIntake = [];
        self.calIntake = [];
        self.activeCals = [];
    }
}

struct ListItemContent: Identifiable, Sendable
{
    let id: UUID;
    let title: String
    let cals: Int32
    let protein: Int32
    var recordId: Int32 = 0;
    let icon: String;
    var createdAt: Date = Date();
    var type: eLogType;
    
    var compositeId: String {
        "\(type)-\(recordId)-\(id)"
    }

    nonisolated init(id: UUID = UUID(), title: String, cals: Int32, protein: Int32, icon: String, type: eLogType)
    {
        self.id = id
        self.title = title
        self.cals = cals
        self.icon = icon
        self.protein = protein
        self.type = type;
    }
    
    nonisolated init(recordId: Int32, title: String, cals: Int32, protein: Int32, icon: String, type: eLogType)
    {
        self.recordId = recordId
        self.title = title
        self.cals = cals
        self.id = UUID ()
        self.icon = icon;
        self.protein = protein
        self.type = type
    }
    
    nonisolated init(recordId: Int32, title: String, cals: Int32, protein: Int32, icon: String, type: eLogType, createdAt: Date)
    {
        self.recordId = recordId
        self.title = title
        self.cals = cals
        self.id = UUID ()
        self.icon = icon;
        self.protein = protein
        self.type = type;
        self.createdAt = createdAt;
    }
}

enum eLogType: Sendable
{
    case meal
    case workout
}

enum ViewType: String, CaseIterable, Identifiable
{
    case meals = "Meals";
    case exercises = "Exercises";
    
    var id: String {rawValue}
}

enum eTab: Hashable
{
    case TODAY;
    case INVENTORY;
    case PROGRESS;
}

enum eProgressDuration: String, CaseIterable, Identifiable
{
    case WEEK   = "Week";
    case MONTH  = "Month";
    
    var id: String {rawValue}
}

struct UserProfile: Sendable
{
    let name:   String;
    let age:    Int32;
    let weight: Int32;
    let height: Int32;
    let bmr:    Int32;
    
    nonisolated init (name: String, age: Int32, weight: Int32, height: Int32, bmr: Int32)
    {
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.bmr = bmr
    }
}

struct Today: Sendable
{
    let date:       String;
    let deficit:    Int32;
    let consumed:   Int32;
    let protein:    Int32;
    let active:     Int32;
    let updated:    Int64;
    
    nonisolated init (date: String, deficit: Int32, consumed: Int32, protein: Int32, active: Int32, updated: Int64)
    {
        self.date = date;
        self.deficit = deficit;
        self.consumed = consumed;
        self.active = active;
        self.updated = updated;
        self.protein = protein;
    }
}

func formatDisplayDate (from dateString: String) -> String?
{
    let parseStrategy = Date.ISO8601FormatStyle()
        .year().month().day()
        .dateSeparator(.dash)
    
    guard let date = try? Date(dateString, strategy: parseStrategy) else {
        return nil
    }
    
    // Formats into: EEE d MMM (e.g., "Fri 2 Oct")
    return date.formatted(
        .dateTime
            .weekday(.abbreviated)
            .day()
            .month(.abbreviated)
    )
}
