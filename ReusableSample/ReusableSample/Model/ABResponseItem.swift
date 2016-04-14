////
////  ABBaseModel.swift
////
////  Created by RJ on 02/03/16.
////  Copyright © 2016 Above Solution. All rights reserved.
////
//
//import UIKit
//
///**
// This are the type of value, that are expected from JSON.
//*/
//enum ABExpectedType {
//    case ABUnknow = 0, ABArray, ABDictionary, ABString, ABDouble, ABInt, ABBool
//}
//
///**
// This protocol help to support Unit test for models.
// You need to extend ABResponseItem to supprt this protocol
//*/
//protocol ABTestSupport {
//    
//    func handleTypeMismatchForValue(value: AnyObject?, exrectedType: ABExpectedType)
//}
//
///**
// This model object help validation type safety of json response.
// We cannot use this for encapsulate any data.
//*/
//final class ABResponseItem: NSObject {
//    
//    var item: AnyObject?
//    
//    init(value: AnyObject) {
//        
//        item = value
//        super.init()
//    }
//    
//    var dictionary: [String: ABResponseItem]? {
//        get {
//            if let item = dictionaryValue {
//                return item.reduce([String : ABResponseItem]()) { (dictionary: [String : ABResponseItem], element: (String, AnyObject)) -> [String : ABResponseItem] in
//                    var d = dictionary
//                    d[element.0] = ABResponseItem(element.1)
//                    return d
//                }
//            } else {
//                return nil
//            }
//        }
//    }
//    
//    var dictionaryValue: [String: AnyObject]? {
//        get {
//            if let item = item as? [String: AnyObject] {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABDictionary)
//                return nil
//            }
//        }
//    }
//    
//    var array: [ABResponseItem]? {
//        get {
//            if let item = arrayValue {
//                return item.map({ (object) -> ABResponseItem in
//                    ABResponseItem(value: object)
//                })
//            } else {
//                return nil
//            }
//        }
//    }
//    
//    var arrayValue: [AnyObject]? {
//        get {
//            if let item = item as? [AnyObject] {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABArray)
//                return nil
//            }
//        }
//    }
//    
//    var stringValue: String? {
//        get {
//            if let item = item as? String {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABString)
//                return nil
//            }
//        }
//    }
//    
//    var doubleValue: Double? {
//        get {
//            if let item = item as? Double {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABDouble)
//                return nil
//            }
//        }
//    }
//    
//    var intValue: Int? {
//        get {
//            if let item = item as? Int {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABString)
//                return nil
//            }
//        }
//    }
//    
//    var boolValue: Bool? {
//        get {
//            if let item = item as? Bool {
//                return item
//            } else {
//                handleErrorForValue(item, type: .ABBool)
//                return nil
//            }
//        }
//    }
//}
//
//extension ABResponseItem : Swift.SequenceType {
//    subscript(index: Int) -> ABResponseItem? {
//        get {
//            if let item = arrayValue where item.count > index {
//                return ABResponseItem(value: item[index])
//            }
//            
//            return nil
//        }
//    }
//    
//    subscript(key: String) -> ABResponseItem? {
//        get {
//            if let item = dictionaryValue, value = item[key] {
//                return ABResponseItem(value: value)
//            }
//            
//            return nil
//        }
//    }
//    
//    func generate() -> AnyGenerator<ABResponseItem> {
//        
//        //If item is array
//        if let list = item as? [AnyObject] {
//            
//            // keep the index of the next car in the iteration
//            var nextIndex = list.count - 1
//            
//            return anyGenerator {
//                if (nextIndex < 0) {
//                    return nil
//                }
//                return ABResponseItem(value: list[nextIndex--])
//            }
//            
//            // If item is dictionary
//        } else if let item = item as? [String: AnyObject] {
//            var nextIndex = item.keys.count - 1
//            
//            return anyGenerator {
//                if (nextIndex < 0) {
//                    return nil
//                }
//                let index = item.startIndex.advancedBy(nextIndex--)
//                return ABResponseItem(value: item.keys[index])
//            }
//        } else {
//            handleErrorForValue(item, type: .ABUnknow)
//
//            return anyGenerator {
//                return nil
//            }
//        }
//    }
//}
//
//private extension ABResponseItem {
// 
//    func handleErrorForValue(value: AnyObject?, type: ABExpectedType) {
//        if let handler = self as? ABTestSupport {
//            handler.handleTypeMismatchForValue(value, exrectedType: type)
//        }
//    }
//    
//}
