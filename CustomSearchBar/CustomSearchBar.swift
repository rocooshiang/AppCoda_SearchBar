//
//  CustomSearchBar.swift
//  CustomSearchBar
//
//  Created by Geosat-RD01 on 2015/10/28.
//  Copyright © 2015年 Appcoda. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    /***
    注意: 搜尋列(search bar)不是一個由textfield (搜尋文字框： search field)分支而成的單一的控制元件。相反的, Bar(search bar)擁有一個UIView view 作為subview, 並且這個 view 包含了其他兩個重要的 subviews: 搜尋文字框(實際上有 UITextField 類別構成的子類別), 和搜尋文字框的背景視圖(background view)。
    ***/
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        
        //儲存字型跟文字顏色的參數以供等等我們來使用
        preferredFont = font
        preferredTextColor = textColor
        
        
//        改變預設搜索Bar的風格(style)，使搜尋列(search bar)變成translucent(半透明)背景並且搜尋文字框(search field)變的不透明。
        searchBarStyle = UISearchBarStyle.Prominent
        
        //搜尋列(search bar)和搜索文字框(search field)都是不透明
        translucent = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //返回我們在搜索欄的子視圖(subview)它的index指標
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for var i=0; i<searchBarView.subviews.count; ++i {
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                break
            }
        }
        
        return index
    }
    
    override func drawRect(rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            // Set its frame，略小於搜尋列(search bar)
            searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        //建立了一個新的 bezier path 跟我們要繪畫的直線
        let startPoint = CGPointMake(0.0, frame.size.height)
        let endPoint = CGPointMake(frame.size.width, frame.size.height)
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        
        //建立一個CAShapeLayer 圖曾來設定bezier path, 並且用來指定直線的顏色跟寬度
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = preferredTextColor.CGColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
        
        super.drawRect(rect)
    }
    
}
