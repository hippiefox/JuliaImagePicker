//
//  JuliaPhotosAccess.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
import Photos

public struct JuliaPhotosAccess {
    public static var photoAuthString: String?
    public static var confirmString: String?
    public static var cancelString: String?

    public typealias JuliaPhotosAccessBlock = (Bool) -> Void

    public static func request(from controller: UIViewController?,
                               completion: @escaping JuliaPhotosAccessBlock) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .restricted, .denied:
                    if let controller = controller {
                        self.authAlert(from: controller, completion: completion)
                    }
                case .authorized, .limited:
                    completion(true)
                default: break
                }
            }
        }
    }

    private static func authAlert(from controller: UIViewController,
                                  completion: @escaping JuliaPhotosAccessBlock) {
        let ac = UIAlertController(title: JuliaPhotosAccess.photoAuthString, message: nil, preferredStyle: .alert)
        if let confirmString = JuliaPhotosAccess.confirmString {
            let action = UIAlertAction(title: confirmString, style: .default) { _ in
                if #available(iOS 16, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openNotificationSettingsURLString)!)

                } else {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            }
            ac.addAction(action)
        }

        if let cancelString = JuliaPhotosAccess.cancelString {
            let action = UIAlertAction(title: cancelString, style: .default) { _ in
                completion(false)
            }
            ac.addAction(action)
        }
        controller.present(ac, animated: true)
    }
}
