//
//  Client.swift
//  HotelManzana
//
//  Created by Yurii Pankov on 27.07.2021.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var WiFi: Bool
    var roomType: RoomType
    
    static let wifiCostPerDay = 12
}
