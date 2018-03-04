//
//  ViewController.swift
//  YDPickerView
//
//  Created by ZJXN on 2018/3/2.
//  Copyright © 2018年 YDZhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YDPickerView"
    }
    
    @IBAction func btnClick1(_ sender: Any) {

        // 数据源
        var room1 = [String](), room2 = [String](), room3 = [String]()
        for i in 1..<10 {
            room1.append("\(i)室")
            room2.append("\(i)厅")
            room3.append("\(i)卫")
        }
        let data = [room1, room2, room3]
        
        //
        YDPickerView.showPickerView(targetView: self.view, dataSource: data).setMiddleTitle("设置中间的标题").complete { (selectedState) in
            // 这个闭包在点击确定按钮后触发
            // 闭包中传入了一个YDPickerView.SelectedState类型的参数, 是一个结构体.在这里命名为 selectedState, 主要作用是描述当前pickerView的选择状态
            
            // 获取指定component的选中row的下标, component的小标从零开始.
            let index1 = selectedState.selectedRow(inComponent: 2)
            print("第2列中选中了第 \(index1) 行")
            
            // 如果你觉得上面的写法有些复杂, 那么你可以这么写, 效果是一样的.
            let index2 = selectedState[2]
            print("第2列中选中了第 \(index2) 行")
            
            // 如果你想获取所有的列的选择状态, selectedState还支持 for in 遍历
            for selectedIndex in selectedState{
                
                let componentIndex = selectedIndex.component // 列
                let rowIndex = selectedIndex.row // 行
                
                print("第 \(componentIndex) 列中选中了第 \(rowIndex) 行")
            }
            
        }
        
        // 如果不需要设置中间标题, 直接调用complete()方法也可以
        /*
         
        YDPickerView.showPickerView(targetView: self.view, dataSource: data).complete { (selectedState) in
            // ....
        }
        */
    }
    
    @IBAction func btnClick2(_ sender: Any) {
        
        var room1 = [String](), room2 = [String](), room3 = [String]()
        for i in 1..<10 {
            room1.append("\(i)室")
            room2.append("\(i)厅")
            room3.append("\(i)卫")
        }
        let data = [room1, room2, room3]
        
        YDPickerView.showPickerView(targetView: self.view, componentCount: data.count, numbeOfRowsInComponent: { (component) -> Int in
            // 这个闭包用于返回每列的行数
            return data[component].count
        }, titleForIndexPath: { (index) -> String in
            // 这个闭包用于返回每列每行的标题
            return data[index.component][index.row]
        }).complete { (selectedState) in
            
            // 这个闭包在点击确定按钮后触发
            // 闭包中传入了一个YDPickerView.SelectedState类型的参数, 是一个结构体.在这里命名为 selectedState, 主要作用是描述当前pickerView的选择状态
            
            // 获取指定component的选中row的下标, component的小标从零开始.
            let index1 = selectedState.selectedRow(inComponent: 2)
            print("第2列中选中了第 \(index1) 行")
            
            // 如果你觉得上面的写法有些复杂, 那么你可以这么写, 效果是一样的.
            let index2 = selectedState[2]
            print("第2列中选中了第 \(index2) 行")
            
            // 如果你想获取所有的列的选择状态, selectedState还支持 for in 遍历
            for selectedIndex in selectedState{
                
                let componentIndex = selectedIndex.component // 列
                let rowIndex = selectedIndex.row // 行
                
                print("第 \(componentIndex) 列中选中了第 \(rowIndex) 行")
            }
        }.setMiddleTitle("设置中间的标题") // 设置中间标题
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

