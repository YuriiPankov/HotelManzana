//
//  Room.swift
//  HotelManzana
//
//  Created by Yurii Pankov on 27.07.2021.
//

import Foundation



struct RoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Double
    
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var all: [RoomType]{
        return [RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179), RoomType(id: 1, name: "One King", shortName: "K", price: 209), RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309)]
    }
}
