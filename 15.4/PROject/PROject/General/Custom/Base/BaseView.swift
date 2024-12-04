//
//  BaseView.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit
import SwifterKnife

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BaseControl: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() { }
    
    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected else { return }
            updateWhenSelectStateDidChange(isSelected)
        }
    }
    func updateWhenSelectStateDidChange(_ selected: Bool) {}
    
    override var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else { return }
            updateWhenEnableStateDidChange(isEnabled)
        }
    }
    func updateWhenEnableStateDidChange(_ enabled: Bool) {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BaseTableCell: UITableViewCell, Reusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseCollectionCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
