//
//  list.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ListWithTitle: View
{
    @State
    var contents: [ListItemContent];
    let title: String;
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text(title)
                .font(.footnote)
                .bold()
            Divider ()
            
            ForEach (contents, id: \.id)
            {item in
                ListItem (pTitle: item.title, pFootnote: item.footnote)
                {
                    deleteItem (item.id)
                }
                
                if item.id != contents.last?.id
                {
                    Divider ()
                }
            }
        }
        .padding(.top)
    }
    
    private func deleteItem (_ id: UUID) -> Void
    {
        contents.removeAll { $0.id == id }
    }
}
