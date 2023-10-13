//
//  CalendarStore.swift
//  Private
//
//  Created by 박성훈 on 10/13/23.
//

import Foundation

class CalendarData: ObservableObject {
    @Published var titleOfMonth: Date = Date()
    @Published var currentPage: Date = Date()
}
