//
//  inventory.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct InvHeader: View
{
    @State
    var showSheet: Bool = false;
    var pViewType: ViewType;
    
    let pAddNewItem: (_ pTitle: String, _ pCals: Int) -> Void;
    
    var body: some View
    {
        HStack
        {
            Text ("Inventory").font(.title)
            Spacer()
            Button ("add", systemImage: "plus")
            {
                showSheet = true;
            }
            .labelStyle(.iconOnly)
            .sheet (isPresented: $showSheet, onDismiss: onDismiss) {
                AddInvSheet (pViewType: pViewType, pSubmit: pAddNewItem)
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .frame(maxWidth: .infinity)
        .debug()
    }
    
    private func onDismiss () -> Void
    {
        showSheet = false;
    }
}

struct InventoryScreen: View
{
    @State
    private var viewType: ViewType = .meals
    
    @State
    private var meals: [ListItemContent] = [
        ListItemContent(title: "Oats and banana", footnote: "320 kcal"),
        ListItemContent(title: "Boiled eggs x3", footnote: "210 kcal"),
        ListItemContent(title: "Chicken rice bowl", footnote: "620 kcal")
    ];
    
    @State
    var activities: [ListItemContent] = [
        ListItemContent (title: "Walk, 10 km", footnote: "+460 kcal"),
        ListItemContent (title: "Badminton", footnote: "+120 kcal"),
    ];
    
    var body: some View
    {
        ScrollView
        {
            VStack (alignment: .leading)
            {
                InvHeader (pViewType: viewType, pAddNewItem: addItem(_:_:))
                InvSwitchView (pViewType: $viewType, meals: $meals, activities: $activities)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.all)
        }
    }
    
    private func addItem (_ pTitle: String, _ pCals: Int) -> Void
    {
        let item = ListItemContent(title: pTitle, footnote: "\(pCals) kcal");
        
        if viewType == .meals
        {
            meals.append (item);
            return;
        }
        
        activities.append (item);
    }
}
