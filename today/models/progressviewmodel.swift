//
//  progressviewmodel.swift
//  today
//
//  Created by Raunit Shrivastava on 05/10/26.
//

import SwiftUI

@Observable
class ProgressViewModel
{
    static let shared =  ProgressViewModel ();
    
    var progress: Progress = Progress (totalDeficit: 7069);
    var pDuration: eProgressDuration = .WEEK;
}
