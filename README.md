# YDPickerView
一行代码完成`PickerView`的展示

最近一直在写项目, 总会用到`UIPickerView`, 但是每次都要设置`DataSource`和`Delegate`非常的烦躁, 非常简单的选择功能加上动画需要写二三百行代码, 代码也是大同小异, 所以把这一功能封装起来, 一行代码完成`PickerView`的展示(这行代码可能有点长:-)), 数据, 标题, 和监听. 

效果如下:

<img src="http://zhaoyanda-git.oss-cn-beijing.aliyuncs.com/YDPickerView.gif" width = "375" height = "667" alt="图片名称" align=center />

### 导入方法
只需要把YDPickerView.swift的文件拖入项目即可.

### 使用方法

#### 初始化和展示
YDPickerView 提供了两个设置数据并展示的方法

<pre><code>
class func showPickerView(targetView: UIView, dataSource: [[String]]) -> YDPickerView
    
class func showPickerView(targetView: UIView, componentCount: Int, numbeOfRowsInComponent: @escaping (Int) -> Int, titleForIndexPath: @escaping (_ indexPath: (component: Int, row: Int)) -> String) -> YDPickerView
</code></pre>

如果需要展示的数据易于封装在二维数组内, 也就是需要展示的数据容易转化为`[[String]]`类型, 那么就可以使用第一个方法直接传入展示的数据, 非常方便. 一行代码即可显示`PickerView`

当然可能需要展示的数据需要在模型中去除或者有着复杂的层级关系, 那么第一种方式就可能力不从心了, 这时就比较推荐第二种方法, 两个回调的函数(闭包), 分别是用于返回`component`(列)数量的回调和返回每列中每行的标题的回调. 很类似于`UIPickerView`的数据源方法.

更详细的使用详见Demo

### 选择完成和PickerView滚动的回调

选择完成和UIPickerView滚动的回调, 分别使用到下面两个方法.

<pre><code>
/// 点击确定后的回调
func complete(_ closure: @escaping (SelectedState) -> Void) -> YDPickerView

/// 监听PickerView滚动的回调
func addScrollObserver(_ closure: @escaping (SelectedState) -> Void) -> YDPickerView
</code></pre>

点击去确定后的闭包中会传入一个`SelectedState`类型的参数, 这个类型是一个结构体, 用于描述PickerView每行每列的选择情况, 支持下标语法, for in 循环

<pre><code>
YDPickerView.showPickerView(targetView: self.view, dataSource: data).complete { (selectedState) in
        
        // 确定按钮点击回调
        // 闭包中传入了一个YDPickerView.SelectedState类型的参数, 是一个结构体.在这里命名为 selectedState, 主要作用是描述当前pickerView的选择状态
        
        // 获取指定component的选中row的下标, component的下标从零开始.
        let index1 = selectedState.selectedRow(inComponent: 2)
        print("第2列中选中了第 \(index1) 行")
        
        // 如果你觉得上面的写法有些复杂, 那么你可以这么写, 效果是一样的.
        let index2 = selectedState[2]
        print("第2列中选中了第 \(index2) 行")
        
        // 如果你想获取所有的列的选择状态, selectedState还支持 for in 遍历
        for selectedIndex in selectedState{
            print("第 \(selectedIndex.component) 列中选中了第 \(selectedIndex.row) 行")
        }
        
    }
</code></pre>

YDPickerView支持链式编程, 再次初始化方法后, 可以直接使用`.`语法继续调用其他方法.

### 设置动画类型和中间标题

动画默认的是渐隐渐现动画, 但也可设置从屏幕下方弹出的动画.
toolBartoolBar中间的标题默认是没有的, 需要设置可以直接调用对应方法.

<pre><code>
/// 设置动画模式
func setAnimationMode(_ mode: ShowMode) -> YDPickerView
/// 用于设置toolBar中间的标题
func setMiddleTitle(_ title: String) -> YDPickerView
</code></pre>
同样支持链式编程.

### 个性化
考虑到小伙伴们风格各异的App中可能使用YDPickerView. 所以我尽可能多的把一些配置提取出来, 定义成公共常量, 以便小伙伴们自己定义.

<pre><code>
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
</code></pre>

如果用的还可以, 别忘了给我`Star`哦 :-)




