//
//  JuliaImageCell.swift
//  JuliaImagePicker
//
//  Created by pulei yu on 2023/10/31.
//

import Foundation
import Photos

open class JuliaImageCell: JuliaPrototypeImageCell {
    public lazy var checkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        view.tintColor = .systemBlue
        return view
    }()

    public lazy var videoMarkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "video"))
        view.tintColor = .systemBlue
        return view
    }()

    public lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()

    override open var asset: PHAsset? {
        didSet {
            guard let asset = asset else { return }

            let isShowVideoMark = asset.duration > 0 ? true : false

            videoMarkImageView.isHidden = !isShowVideoMark
            durationLabel.isHidden = !isShowVideoMark
            durationLabel.text = Int(asset.duration).covert2TimeFormat()
        }
    }

    open var isChoosed: Bool = false {
        didSet {
            checkImageView.isHidden = !isChoosed
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        checkImageView.isHidden = true
        contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 22, height: 22))
            $0.top.equalTo(8)
            $0.right.equalToSuperview().offset(-8)
        }
        videoMarkImageView.isHidden = true
        contentView.addSubview(videoMarkImageView)
        videoMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.left.equalTo(6)
            $0.bottom.equalToSuperview().offset((-6))
        }
        durationLabel.isHidden = true
        contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints {
            $0.centerY.equalTo(videoMarkImageView)
            $0.left.equalTo(videoMarkImageView.snp.right).offset(2)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Int {
    func covert2TimeFormat() -> String {
        let second = self
        let h = second / 3600
        let m = second % 3600 / 60
        let s = second % 60
        let hStr = String(format: "%02d", h)
        let mStr = String(format: "%02d", m)
        let sStr = String(format: "%02d", s)
        if h > 0 { return "\(hStr):\(mStr):\(sStr)" }
        if m > 0 { return "\(mStr):\(sStr)" }
        return "0:\(sStr)"
    }
}
