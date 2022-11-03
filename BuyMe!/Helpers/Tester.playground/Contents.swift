import UIKit

var itemList: [String : Int] = [:]
var itemIds: [String] = ["ali", "veli", "ali", "ali", "mehmet"]


func dictMaker() -> [String : Int]{
    var newValue: Int = 1
    for item in itemIds {
        if itemList[item] != nil {
            newValue = newValue + 1
            itemList.updateValue(newValue, forKey: item)
        } else {
            itemList = [item : 1]
        }
    }
    return itemList
}

dictMaker()
