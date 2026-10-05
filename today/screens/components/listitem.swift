//
//  ListItem.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
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
                Text (pItem.icon)
                    .font(.title)
                
                VStack (alignment: .leading)
                {
                    Text (pItem.title).font(.body)
                    
                    HStack
                    {
                        Text ("\(pItem.cals) kcal").font(.footnote)
                        
                        if pItem.protein > 0
                        {
                            Dot ()
                            Text ("\(pItem.protein) g").font(.footnote)
                        }
                    }
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
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
        
    }
}
