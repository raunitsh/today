//
//  list.swift
//  today
//
//  Created by Raunit Shrivastava on 02/10/26.
//

import SwiftUI

struct ListWithTitle: View
{
    let contents: [ListItemContent];
    let title: String;
    let pAction: (_ pItem: UUID) -> Void;
    
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
                    pAction (item.id)
                }
                
                if item.id != contents.last?.id
                {
                    Divider ()
                }
            }
        }
        .padding(.top)
    }    
}
