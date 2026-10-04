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
        TabView
        {
            NavigationStack
            { SummaryScreen () }.tabItem
            { Label ("Today", systemImage: "house") }
            
            NavigationStack
            { InventoryScreen () }.tabItem
            { Label ("Inventory", systemImage: "house") }
            
            NavigationStack
            { SummaryScreen () }.tabItem
            { Label ("Progress", systemImage: "house") }
        }
        .task
        {
            InitBackend ();
        }
    }
    
    private func InitBackend () -> Void
    {
        let filemanager = FileManager.default;
        if let docsUrl = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            Task
            {
                if await !Backend.shared.Init (docsUrl)
                {
                    print ("Backend init failed");
                }
                
                UserViewModel.shared.Init ();
                TodayViewModel.shared.Init ();
                InventoryViewModel.shared.Init ();
            }
        }
    }
}

#Preview {
    ContentView()
}
