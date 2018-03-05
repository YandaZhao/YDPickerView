//
//  ViewController.swift
//  YDPickerView
//
//  Created by ZJXN on 2018/3/2.
//  Copyright © 2018年 YDZhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 数据源
    private lazy var data: [[String]] = {
        var room1 = [String](), room2 = [String](), room3 = [String]()
        for i in 1..<10 {
            room1.append("\(i)室")
            room2.append("\(i)厅")
            room3.append("\(i)卫")
        }
        return [room1, room2, room3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YDPickerView"
    }
    
    @IBAction func btnClick1(_ sender: Any) {
        
        YDPickerView.showPickerView(targetView: self.view, dataSource: data).setAnimationMode(.fromBottom)
        
        /*
         
        YDPickerView.showPickerView(targetView: self.view, dataSource: data).complete { (selectedState) in
            // ....
        }
        */
    }
    
    @IBAction func btnClick2(_ sender: Any) {
        
        YDPickerView.showPickerView(targetView: self.view, componentCount: data.count, numbeOfRowsInComponent: { (component) -> Int in
            // 这个闭包用于返回每列的行数
            return self.data[component].count
        }, titleForIndexPath: { (index) -> String in
            // 这个闭包用于返回每列每行的标题
            return self.data[index.component][index.row]
        }).complete({ (selectedState) in
            // 确定按钮点击回调
            // code...
        }).addScrollObserver({ (selectedState) in
            // PickerView点击确定回调
            // code...
        }).setMiddleTitle("设置中间的标题").setAnimationMode(.fromBottom) // 设置动画模式
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

