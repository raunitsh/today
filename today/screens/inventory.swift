//
//  inventory.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct InvHeader: View
{
    var body: some View
    {
        HStack
        {
            Text ("Inventory").font(.title)
            Spacer()
            Button ("add", systemImage: "plus")
            {
                
            }
            .labelStyle(.iconOnly)
            
        }
        .frame(maxWidth: .infinity)
        .debug()
    }
}

struct InventoryScreen: View
{
    var body: some View
    {
        ScrollView
        {
            VStack (alignment: .leading)
            {
                InvHeader ()
                InvSwitchView ()
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.all)
        }
    }
}
