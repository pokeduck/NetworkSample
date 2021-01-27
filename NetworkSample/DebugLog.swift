//
// DebugLog.swift
//
// Created by Ben for NetworkSample on 2021/1/27.
// Copyright © 2021 Alien. All rights reserved.
//

import Foundation
func dLog(_ message: Any,
          function: String = #function,
          file: String = #file,
          line: Int = #line)
{
    let url = URL(fileURLWithPath: file)
    let fileName = url.lastPathComponent
    var msg = ""
    if let m = message as? String {
        msg = m
    } else {
        msg = String(describing: message)
    }
    print("[Log] \"\(msg)\" [\(fileName) : \(function)][\(line)]")
}

func funcLog(function: String = #function,
             file: String = #file,
             line: Int = #line)
{
    dLog("", function: function, file: file, line: line)
}
