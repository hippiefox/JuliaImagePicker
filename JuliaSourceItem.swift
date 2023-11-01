//
//  JuliaSourceItem.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
public struct JuliaSourceItem: Hashable{
    public let name: String
    public let ext: String
    public let localId: String
    public let localPath: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(localId)
    }
}
