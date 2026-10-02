//
//  eatentodayy.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct EatenToday: View
{
    @Bindable
    var v = TodayViewModel.shared;
    
    var body: some View
    {
        ListWithTitle(contents: v.eatenToday, title: "Eaten today")
        {id in
            v.eatenToday.removeAll {
                $0.id == id;
            }
        }
    }
}
