//
//  ProfileViewModel.swift
//  UGolf
//
//  Created by Lon Chandler Madsen on 10/5/21.
//

import Foundation

enum ProfileViewModelType {
    case info, scores, otherUsers, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
