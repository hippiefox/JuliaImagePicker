//
//  JuliaPrototypeImageCell.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
import Photos
import SnapKit

open class JuliaPrototypeImageCell: UICollectionViewCell {
    public var deliveryMode: PHImageRequestOptionsDeliveryMode = .fastFormat
    public lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()


    open var asset: PHAsset? {
        didSet {
            guard let asset = asset else { return }
            loadPhotoIfNeeded()
        }
    }

    public var __requestID: PHImageRequestID?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        let manager = PHImageManager.default()
        guard let reqId = __requestID else { return }
        manager.cancelImageRequest(reqId)
        __requestID = nil
    }

    open func loadPhotoIfNeeded() {
        guard let asset = asset else { return }

        __requestID = JuliaImageFetcher.default.fetchSuitableImage(asset: asset, resizeWidth: bounds.width * 2, delivertMode: .fastFormat) { [weak self] img in
            guard let self = self else { return }
            self.__requestID = nil
            self.iconImageView.image = img
        }
    }
}
