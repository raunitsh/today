//
//  eatentodayy.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct EatenToday: View
{
    @State
    private var meals: [ListItemContent] = [
        ListItemContent(title: "Oats and banana", footnote: "320 kcal"),
        ListItemContent(title: "Boiled eggs x3", footnote: "210 kcal"),
        ListItemContent(title: "Chicken rice bowl", footnote: "620 kcal")
    ]
    
    var body: some View
    {
        ListWithTitle(contents: meals, title: "Eaten today")
        {id in
            meals.removeAll {
                $0.id == id;
            }
        }
    }
}
