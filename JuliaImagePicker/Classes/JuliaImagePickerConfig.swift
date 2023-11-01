//
//  JuliaImagePickerConfig.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
public struct JuliaImagePickerConfig{
    public static var maxSelectedCount = 0
    
    public static var columnCount = 3
    
    public static var fetchPageSize = 100
    
    public static var itemSpace: CGFloat = 10
    
    public static var sectionInset: UIEdgeInsets = .init(top: (15), left: (15), bottom: (15), right: (15))

    public static func layout(within containerWidth: CGFloat)-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        var itemWidth = (containerWidth - (sectionInset.left + sectionInset.right) - CGFloat(columnCount - 1) * itemSpace) / CGFloat(columnCount)
        itemWidth = floor(itemWidth)
        layout.minimumLineSpacing = floor(itemSpace)
        layout.minimumInteritemSpacing = floor(itemSpace)
        layout.sectionInset = sectionInset
        layout.itemSize = .init(width: itemWidth, height: itemWidth)
        return layout
    }
    
    public static var logEnable: Bool = false

}


func JLLogImagePicker(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    guard JuliaImagePickerConfig.logEnable else { return }
    print(items, separator: separator, terminator: terminator)
}

