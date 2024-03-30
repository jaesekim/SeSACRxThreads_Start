//
//  UserModel.swift
//  SeSACRxThreads
//
//  Created by 김재석 on 3/30/24.
//

import Foundation

struct User: Hashable, Identifiable {
    let id = UUID()
    let name: String
}
