//
//  HUD+Action.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import Foundation
import UIKit
import SwifterKnife

protocol HUDActionAdded: HUDDismissable {
    func afterAddButton(_ button: UIControl, _ vOffset: CGFloat?)
    var onDimiss: ((Any) -> Void)? { get set }
}
extension HUDActionAdded {
    func setOnDismiss(_ closure: @escaping (_ this: Self, _ tag: Int) -> Void) {
        self.onDimiss = { p in
            guard let info = p as? (Self, Int) else { return }
            closure(info.0, info.1)
        }
    }
    
    func dismiss(with tag: Int, completion: ((_ this: Self, _ tag: Int) -> Void)? = nil) {
        self.dismiss { [unowned self] in
            completion?(self, tag)
            self.onDimiss?((self, tag))
        }
    }
    
    func _addAction(_ button: UIControl,
                    vOffset: CGFloat? = nil,
                    closure: @escaping (Self, UIControl) -> Void) -> UIControl {
        button.addTouchUpInsideClosure { [unowned self] sender, event in
            closure(self, sender)
        }
        afterAddButton(button, vOffset)
        return button
    }
    
    @discardableResult
    func addAction(_ button: UIControl,
                   vOffset: CGFloat? = nil,
                   closure: (() -> Void)? = nil) -> UIControl {
        _addAction(button, vOffset: vOffset) { this, sender in
            this.dismiss(with: sender.tag) { this, tag in
                closure?()
            }
        }
    }
    @discardableResult
    func addAction1(_ button: UIControl,
                    vOffset: CGFloat? = nil,
                    closure: @escaping (Self) -> Void) -> UIControl {
        _addAction(button, vOffset: vOffset) { this, _ in
            closure(this)
        }
    }
    @discardableResult
    func addAction2(_ button: UIControl,
                    vOffset: CGFloat? = nil,
                    closure: @escaping (Self, UIControl) -> Void) -> UIControl {
        _addAction(button, vOffset: vOffset) { this, sender in
            this.dismiss(with: sender.tag) { this, tag in
                closure(this, sender)
            }
        }
    }
}


extension HUD {
    class ActionView: HUD.ContentView, HUDActionAdded {
        
        var topContainerEdgeInset: UIEdgeInsets {
            .init(top: 28.fit, left: h20, bottom: 0, right: h20)
        }
        var bottomContainerEdgeInset: UIEdgeInsets {
            .init(top: h20, left: h20, bottom: h20, right: h20)
        }
        
        override func setup() {
            super.setup()
            
            backgroundColor = UIColor(gray: 0, alpha: 0.4)
            
            let tInset = topContainerEdgeInset
            
            topContainer = VirtualView().then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(tInset.top)
                    make.leading.equalTo(tInset.left)
                    make.trailing.equalTo(-tInset.right)
                }
            }
            let bInset = bottomContainerEdgeInset
            bottomContainer = .vertical.then {
                $0.alignment = .fill
                $0.distribution = .fillEqually
                $0.spacing = 6
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(topContainer.snp.bottom).offset(bInset.top)
                    make.leading.equalTo(bInset.left)
                    make.trailing.equalTo(-bInset.right)
                    make.bottom.equalTo(-bInset.bottom)
                }
            }
        }
        func afterAddButton(_ button: UIControl, _ vOffset: CGFloat?) {
            if let space = vOffset,
                let last = bottomContainer.arrangedSubviews.last {
                bottomContainer.setCustomSpacing(space, after: last)
            }
            bottomContainer.addArrangedSubview(button)
        }
        var onDimiss: ((Any) -> Void)?
        
        private(set) unowned var topContainer: VirtualView!
        private(set) unowned var bottomContainer: UIStackView!
    }
     
}
