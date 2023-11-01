//
//  JuliaSourceManager.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
import Photos

public final class JuliaSourceManager {
    public static let `default` = JuliaSourceManager()

    private init() {}

    public let resourcesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + "/MediaResources"
    public var resourcesPath: String { resourcesDirectory + "/Resources" }

    public func createDirectory() {
        try? FileManager.default.createDirectory(atPath: resourcesPath, withIntermediateDirectories: true, attributes: nil)
    }

    public func delete(filePath: String) {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch {
            JLLogImagePicker(#function, "\(filePath) :::>failure")
        }
    }

    public func fetchAssetFilePath(asset: PHAsset, completion: @escaping (String?) -> Void) {
        asset.requestContentEditingInput(with: nil) { input, _ in
            var path = input?.fullSizeImageURL?.absoluteString
            if path == nil, let dir = asset.value(forKey: "directory") as? String, let name = asset.value(forKey: "filename") as? String {
                path = String(format: "file:///var/mobile/Media/%@/%@", dir, name)
            }
            completion(path)
        }
    }

    public func copyPhotosItemToSandbox(with assets: [PHAsset],
                                        completion: ((Set<JuliaSourceItem>) -> Void)? = nil) {
        let group = DispatchGroup()
        var cachedItems: Set<JuliaSourceItem> = []
        let __resourcePath = resourcesPath

        for (_, asset) in assets.enumerated() {
            group.enter()

            fetchAssetFilePath(asset: asset) { filePath in
                guard let filePath = filePath as NSString? else {
                    group.leave()
                    return
                }

                let pathExtension = filePath.pathExtension
                let fileName = (filePath.lastPathComponent as NSString).deletingPathExtension
                let directoryPath = __resourcePath
                let toPath = directoryPath + "/" + fileName + "." + pathExtension

                if FileManager.default.fileExists(atPath: toPath) {
                    // 表示文件已经存在沙盒，此时可以完成拷贝
                    let item = JuliaSourceItem(name: fileName, ext: pathExtension, localId: asset.localIdentifier, localPath: toPath)
                    cachedItems.insert(item)
                    group.leave()
                    return
                }
                let fromPath = filePath.replacingOccurrences(of: "file://", with: "")
                do {
//                    let resourceName = fileName + "." + pathExtension
                    try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
                    let item = JuliaSourceItem(name: fileName, ext: pathExtension, localId: asset.localIdentifier, localPath: toPath)
                    cachedItems.insert(item)
                    JLLogImagePicker("写入沙盒 成功！！！！！")
                } catch {
                    JLLogImagePicker("写入沙盒失败 ---- ，", error.localizedDescription)
                }
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            JLLogImagePicker("拷贝都完成了")
            completion?(cachedItems)
        }
    }
}
