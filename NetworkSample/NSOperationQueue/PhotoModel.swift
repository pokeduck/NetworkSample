//
// PhotoModel.swift
//
// Created by Ben for NetworkSample on 2021/4/26.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation

class PhotoModel {
    let key: String
    private(set) var isCached: Bool
    let url: URL
    init(url: String) {
        isCached = false
        self.url = URL(string: url)!
        self.key = url
    }
}
class PhotoDownloadManager {
    let queue = PhotoDownloadQueue<PhotoModel>()
    func bringToFront(models: [PhotoModel]) {
        queue
    }
}
struct PhotoDownloadQueue<T> {
  fileprivate var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public var front: T? {
    return array.first
  }
}
