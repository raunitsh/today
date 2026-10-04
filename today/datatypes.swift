//
//  datatypes.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ListItem: View
{
    let pItem: ListItemContent;
    
    let pOnDelete: (_ pItem: ListItemContent) -> Void;
    let pOnTap:  (_ pItem: ListItemContent) -> Void;
    
    var body: some View
    {
        HStack
        {
            HStack
            {
                Image (systemName: "frying.pan")
                
                VStack (alignment: .leading)
                {
                    Text (pItem.title).font(.body)
                    Text ("\(pItem.cals) kcal").font(.footnote)
                }
                .debug()
                
                Spacer()
            }
            .onTapGesture
            {
                pOnTap (pItem);
            }
            Button ("delete", systemImage: "xmark")
            {
                pOnDelete (pItem);
            }
                .labelStyle(.iconOnly)
                .tint(.gray)
        }
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity)
        .debug()
    }
}

struct ListItemContent: Identifiable, Sendable
{
    let id: UUID
    let title: String
    let cals: Int32

    nonisolated init(id: UUID = UUID(), title: String, cals: Int32)
    {
        self.id = id
        self.title = title
        self.cals = cals
    }
}

enum ViewType: String, CaseIterable, Identifiable
{
    case meals = "Meals";
    case exercises = "Exercises";
    
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
    let updated:    Int64;
    
    nonisolated init (date: String, deficit: Int32, consumed: Int32, updated: Int64)
    {
        self.date = date
        self.deficit = deficit
        self.consumed = consumed
        self.updated = updated
    }
}
