//
//  ContentView.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ContentView: View
{
    var body: some View
    {
        ScrollView
        {
            SummaryScreen ()
                .border(.red)
        }
    }
}

#Preview {
    ContentView()
}
