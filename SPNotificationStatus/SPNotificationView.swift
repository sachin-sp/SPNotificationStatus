//
//  SPNotificationView.swift
//  SPNotificationStatus
//
//  Created by Sachin Pampannavar on 12/25/19.
//  Copyright © 2019 Sachin Pampannavar. All rights reserved.
//

import UIKit

class SPNotificationView: UIView {

    private var contentView: UIView!
    private var visualEffectView: UIVisualEffectView!
    private var notificationImageView: UIImageView!
    private var notificationTitleLabel: UILabel!
    
    var timer: Timer?
    var isUserInteractionDisabled = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        let blurEffect = UIBlurEffect(style: .light)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        //visualEffectView.frame = self.bounds
        
        self.contentView = visualEffectView!
        addSubview(contentView)
        contentView.alpha = 0.0
        
        visualEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        visualEffectView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        visualEffectView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.notificationImageView = UIImageView()
        visualEffectView.contentView.addSubview(notificationImageView)
        self.notificationTitleLabel = UILabel()
        visualEffectView.contentView.addSubview(notificationTitleLabel)
        
        //Contraints
    
        visualEffectView.contentView.addConstraintsWithFormat("H:|-10-[v0(100)]-8-[v1]-10-|", views: notificationImageView, notificationTitleLabel)
        
        
        visualEffectView.contentView.addConstraintsWithFormat("V:|[v0]|", views: notificationImageView)
        visualEffectView.contentView.addConstraintsWithFormat("V:|-10-[v0]-10-|", views: notificationTitleLabel)
        
        self.notificationTitleLabel.numberOfLines = 0
        
        
    }
    
    // Allow view to control itself
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }
    
    public override func didMoveToSuperview() {
        // Fade in when added to superview
        // Then add a timer to remove the view
        self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }) { _ in
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(self.removeSelf), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func removeSelf() {
        // Animate removal of view
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contentView.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return self.isUserInteractionDisabled
    }
    
    private func attributedText(title: String, detail: String) -> NSAttributedString {
        
        let attributedStr = NSMutableAttributedString()
        
        let titleStr = getAttributedString(text: title, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .heavy), .foregroundColor: UIColor.darkText])
        let detailStr = getAttributedString(text: detail, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium), .foregroundColor: UIColor.darkText])
        
        attributedStr.append(titleStr)
        attributedStr.append(NSAttributedString(string: "\n"))
        attributedStr.append(detailStr)
        
        return attributedStr
        
    }
    
    private func getAttributedString(text: String, attributes:[NSAttributedString.Key: Any]) -> NSAttributedString{
        var attributedString = NSAttributedString()
        let text = text
        let attributes = attributes
        attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    func set(notificationImageName name: String, notificationTitle title: String, notificationDetail detail: String) {
        self.notificationImageView.image = UIImage(named: name)
        let attributedStr = attributedText(title: title, detail: detail)
        self.notificationTitleLabel.attributedText = attributedStr
    }
    
    deinit {
        self.contentView = nil
        self.visualEffectView = nil
        self.notificationImageView = nil
        self.notificationTitleLabel = nil
        self.timer?.invalidate()
        self.timer = nil
    }
}
