//
//  JuliaImageFetcher.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
import Photos

public extension JuliaImageFetcher {
    enum AssetType {
        case photo
        case video
        case both
    }
}

final public class JuliaImageFetcher {
    public static let `default` = JuliaImageFetcher()
    private init(){}

    public var fetchAssetType: AssetType = .both
    public  var assets: [PHAsset] = []
    private var lastLimit: Int = 0

    public lazy var fetchOptions: PHFetchOptions = {
        let opt = PHFetchOptions()
        opt.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        opt.includeHiddenAssets = false
        return opt
    }()

    /// limit: 0表示无限制
    public func fetchAssets(to limit: Int) {
        fetchOptions.fetchLimit = limit

        var fetchResult: PHFetchResult<PHAsset>!

        switch fetchAssetType {
        case .photo:    fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        case .video:    fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        case .both:     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        }

        let fetchedAssets = fetchResult.objects(at: IndexSet(0 ..< fetchResult.count)).map { $0 }
        assets.removeAll()
        assets.append(contentsOf: fetchedAssets)
        lastLimit = limit
    }

    public func clearAll() {
        assets.removeAll()
    }

    public func fetchOriginImage(from asset: PHAsset, completion: @escaping (UIImage?)->Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isSynchronous = false
        // PHImageManagerMaximumSize

        PHImageManager.default().requestImage(for: asset,
                                              targetSize: PHImageManagerMaximumSize,
                                              contentMode: .default,
                                              options: options,
                                              resultHandler: { image, _ in
                                                  completion(image)
                                              })
    }

    @discardableResult
    public func fetchSuitableImage(asset: PHAsset,
                                   resizeWidth: CGFloat = 1080,
                                   isSynchronous: Bool = false,
                                   delivertMode: PHImageRequestOptionsDeliveryMode = .highQualityFormat,
                                   completion: @escaping (UIImage?)->Void)-> PHImageRequestID{
        let options = PHImageRequestOptions()
        options.isSynchronous = isSynchronous
        options.deliveryMode = delivertMode
        options.resizeMode = .fast

        let aspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        var pxW: CGFloat = resizeWidth
        if aspectRatio > 1.8 { // 超宽
            pxW = pxW * aspectRatio
        }
        if aspectRatio < 0.2 {
            pxW = pxW * 0.5
        }

        let imageSize = CGSize(width: pxW, height: pxW / aspectRatio)

        let reqId = PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { resultImg, _ in
            completion(resultImg)
        }
        
        return reqId
    }
}
