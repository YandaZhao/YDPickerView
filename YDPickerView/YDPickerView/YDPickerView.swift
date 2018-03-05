//
//  YDPickerView.swift
//  YDPickerView
//
//  Created by ZJXN on 2018/3/2.
//  Copyright © 2018年 YDZhao. All rights reserved.
//

import UIKit

// const
private let kScreenWidth = UIScreen.main.bounds.width
private let kScreenHeight = UIScreen.main.bounds.height
private let kScreenScale = UIScreen.main.scale
private let kBottomHeight = CGFloat(UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 0)

// toolBar的高度
private let kToolBarHeight: CGFloat = 34.0
// pickerView的高度
private let kPickerViewHeight: CGFloat = 220.0
// pickerView两条指示线的颜色, 如果不需要指示线, 直接设置为UIColor.clear 即可
private let kIndicatorLineColor = UIColor.lightGray
// pickerView的背景色
private let kPickerViewBackgroundColor = UIColor.white
// toolBar背景色
private let kToolBarBackgroundColor = UIColor(red: 44 / 255.0, green: 143 / 255.0, blue: 239 / 255.0, alpha: 1)
// toolBar的tintColor
private let kToolBarTintColor = UIColor.white
// toolBar中间的标题颜色
private let kTitleColor = UIColor.green
// toolBar中间的字体大小
private let kTitleFontSize: CGFloat = 18



class YDPickerView: UIPickerView {
    
    // 弹出动画的类型
    enum ShowMode {
        case fade // 渐隐渐现 默认
        case fromBottom // 从底部弹出
    }
    
    /// 这个结构体用于表示当前PickerView的选择状态, 可获取指定component中的row选择index, 也支持更为方便的下标语法获取, 因遵守了Sequence, IteratorProtocol, 同样也支持for in 方式进行遍历
    struct SelectedState: Sequence, IteratorProtocol {
        
        /// 遵守Sequence, IteratorProtocol协议
        typealias Element = (component: Int, row: Int)
        private var currentIndex = 0
        mutating func next() -> (component: Int, row: Int)? {
            if seletedInfo.keys.contains(currentIndex) {
                let selectedState = (component: currentIndex, row: self[currentIndex])
                currentIndex += 1
                return selectedState
            }else {
                return nil
            }
        }
        
        /// 用于存放选择信息
        private var seletedInfo = [Int: Int]()
        
        /// 可以返回component的个数
        var componentCount: Int {
            return seletedInfo.count
        }
        
        /// 用于返回指定component的选中行的index
        ///
        /// - Parameter index: component下标
        subscript (index: Int) -> Int {
            set {
                seletedInfo[index] = newValue
            }
            get {
                assert(seletedInfo.keys.contains(index), "字典中没有key为\(index)的值")
                return seletedInfo[index]!
            }
        }
        
        /// 用于返回指定component的选中行的index
        ///
        /// - Parameter component: component的下标
        /// - Returns: 返回指定component中选中行的index
        func selectedRow(inComponent component: Int) -> Int {
            return self[component]
        }
    }
    
    // MARK: - Property
    private unowned var targetView: UIView
    private var componentCount = 0
    private var animationMode = ShowMode.fade
    private var numbeOfRowsInComponentClosure: ((Int) -> Int)?
    private var titleForIndexPathClosure: (((Int, Int)) -> String)?
    private var completeClosure: ((SelectedState) -> Void)?
    private var didScrollClosure: ((SelectedState) -> Void)?
    private var data: [[String]]? {
        didSet {
            componentCount = data!.count
        }
    }
    
    /// 当前PickView的选择状态
    private var currentSelectedState: SelectedState {
        var selectedState = SelectedState()
        for i in 0..<componentCount {
            selectedState[i] = selectedRow(inComponent: i)
        }
        return selectedState
    }
    
    
    
    // MARK: - LazyLoad
    /// 背景View
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: targetView.bounds)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap)))
        return view
    }()
    /// 适配iPhoneX的BottomView
    private lazy var bottomView: UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: targetView.bounds.height - kBottomHeight, width: kScreenWidth, height: kBottomHeight))
        bottomView.backgroundColor = kPickerViewBackgroundColor
        return bottomView
    }()
    
    /// 工具条
    private lazy var toolBar: UIToolbar = {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: targetView.bounds.height - (kToolBarHeight + kPickerViewHeight + kBottomHeight), width: kScreenWidth, height: kToolBarHeight))
        let cancelBtnItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelBtnClick))
        cancelBtnItem.width = 60
        let spaceItem1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let completeBtnItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(completeBtnClick))
        completeBtnItem.width = 60
        toolBar.items = [cancelBtnItem, spaceItem1, spaceItem2, completeBtnItem]
        toolBar.tintColor = kToolBarTintColor
        toolBar.barTintColor = kToolBarBackgroundColor
        
        return toolBar
    }()
    
    /// 需要展示的数据不便于直接使用二维数组呈现, 推荐使用此方法
    ///
    /// - Parameters:
    ///   - targetView: PickerView添加到的目标View
    ///   - componentCount: PickerView的列数
    ///   - numbeOfRowsInComponent: PickerView每列的行数
    ///   - titleForIndexPath: 返回每列每行的标题
    /// - Returns: 返回展示的PickerView, 可忽略返回值
    @discardableResult class func showPickerView(targetView: UIView, componentCount: Int, numbeOfRowsInComponent: @escaping (Int) -> Int, titleForIndexPath: @escaping (_ indexPath: (component: Int, row: Int)) -> String) -> YDPickerView {
        
        let pickerView = YDPickerView(targetView: targetView)
        
        // DataSource
        pickerView.componentCount = componentCount
        pickerView.numbeOfRowsInComponentClosure = numbeOfRowsInComponent
        pickerView.titleForIndexPathClosure = titleForIndexPath
        
        //        pickerView.reloadAllComponents()
        
        pickerView.show()
        return pickerView
    }
    
    
    /// 需要展示的数据易于封装在二维数组内, 推荐使用此方法
    ///
    /// - Parameters:
    ///   - targetView: PickerView添加到的目标View
    ///   - dataSource: 此参数类型是一个二维数组, 第一维表示的每列, 第二维表示的每列的每行.
    /// - Returns: 返回展示的PickerView, 可忽略返回值
    @discardableResult class func showPickerView(targetView: UIView, dataSource: [[String]]) -> YDPickerView {
        
        let pickerView = YDPickerView(targetView: targetView)
        pickerView.data = dataSource
        pickerView.show()
        return pickerView
    }
    
    private init(targetView: UIView) {
        
        self.targetView = targetView
        
        super.init(frame: CGRect.zero)
        
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    private func initialization() {
        self.delegate = self;
        self.dataSource = self;
        setupUI()
    }
    
    private func setupUI() {
        
        showsSelectionIndicator = true
        
        backgroundColor = kPickerViewBackgroundColor
        frame = CGRect(x: 0, y: targetView.bounds.height - (kPickerViewHeight + kBottomHeight), width: kScreenWidth, height: kPickerViewHeight)
        
        backgroundView.addSubview(self)
        
        if kBottomHeight != 0 {
            
            backgroundView.addSubview(bottomView)
        }
        
        backgroundView.addSubview(toolBar)
    }
    /// 用于设置toolBar中间的标题
    @discardableResult func setMiddleTitle(_ title: String) -> YDPickerView {
        
        let itemsO = toolBar.items
        guard var items = itemsO else { return self }
        
        let titleLab = UILabel()
        titleLab.text = title
        titleLab.font = UIFont.systemFont(ofSize: kTitleFontSize)
        titleLab.textColor = kTitleColor
        
        items.insert(UIBarButtonItem(customView: titleLab), at: 2)
        toolBar.setItems(items, animated: false)
        return self
    }
    
    /// 点击确定后的回调
    @discardableResult func complete(_ closure: @escaping (SelectedState) -> Void) -> YDPickerView {
        completeClosure = closure
        return self
    }
    
    /// 监听PickerView滚动的回调
    @discardableResult func addScrollObserver(_ closure: @escaping (SelectedState) -> Void) -> YDPickerView {
        didScrollClosure = closure
        return self
    }
    
    /// 设置动画模式
    @discardableResult func setAnimationMode(_ mode: ShowMode) -> YDPickerView {
        self.animationMode = mode
        return self
    }
    
        
    // MARK: - ActionEvent
    /// 展示PicerView
    private func show() {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
        
            switch self.animationMode {
            case .fade:
                fadeModeShow()
            case .fromBottom:
                fromBottomModeShow()
            }
        }
        
        func fadeModeShow() {
            self.backgroundView.alpha = 0
            self.targetView.addSubview(self.backgroundView)
            
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in               self.backgroundView.alpha = 1
                }, completion: nil)
        }
        
        func fromBottomModeShow() {
            self.backgroundView.backgroundColor = UIColor.clear
            let yOffset = kPickerViewHeight + kBottomHeight + kToolBarHeight
            self.transform = CGAffineTransform(translationX: 0, y: yOffset)
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: yOffset)
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: yOffset)
            self.targetView.addSubview(self.backgroundView)
            
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.transform = CGAffineTransform.identity
                self.toolBar.transform = CGAffineTransform.identity
                self.bottomView.transform = CGAffineTransform.identity
                self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.2)
                }, completion: nil)
        }
        
    }

    /// 关闭PickerView
    func close() {

        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.backgroundView.alpha = 0
        }) { [unowned self](_) in
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }   
    }
    
    @objc private func completeBtnClick() {
        
        completeClosure?(currentSelectedState)
        
        close()
    }
    
    @objc private func cancelBtnClick() {
        close()
    }
    
    @objc private func backgroundViewTap() {
        close()
    }
    
    deinit {
        print("YDPickerView销毁了")
    }
}

extension YDPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return componentCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data?[component].count ?? numbeOfRowsInComponentClosure?(component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        didScrollClosure?(currentSelectedState)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        for subView in pickerView.subviews {
            if subView.bounds.height <= 1 {
                subView.backgroundColor = kIndicatorLineColor
            }
        }
        
        var label: UILabel?
        
        switch view {
        case .some(let view) where view.isMember(of: UILabel.self):
            label = view as? UILabel
        default:
            label = UILabel()
            label?.textAlignment = .center
            label?.textColor = UIColor.darkGray
            label?.font = UIFont.systemFont(ofSize: 25)
        }
        
        switch data?[component][row] {
        case .some(let title):
            label?.text = title
        case .none:
            label?.text = titleForIndexPathClosure?((component, row)) ?? ""
        }
        
        return label!
    }
}
