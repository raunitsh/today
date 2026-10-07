//
//  profileviewmodel.swift
//  today
//
//  Created by Raunit Shrivastava on 03/10/26.
//

import SwiftUI

@Observable
class UserViewModel
{
    static let shared = UserViewModel ();
    
    public func Sync () -> Void
    {
        Task
        {
            userProfile = await Backend.shared.LoadProfile ();
        }
    }
    
    var userProfile: UserProfile?;
}
