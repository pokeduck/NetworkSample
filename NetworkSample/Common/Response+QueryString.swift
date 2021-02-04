//
// Response+QueryString.swift
//
// Created by Ben for NetworkSample on 2021/2/4.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
import RxSwift

extension Moya.Response {
    func mapQueryString<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) throws -> D {
        let serializeToData: (Any) throws -> Data? = { (jsonObject) in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw MoyaError.jsonMapping(self)
            }
        }
        let jsonData: Data
        keyPathCheck: if let keyPath = keyPath {
            guard let jsonObject = (try mapJSON(failsOnEmptyData: failsOnEmptyData) as? NSDictionary)?.value(forKeyPath: keyPath) else {
                if failsOnEmptyData {
                    throw MoyaError.jsonMapping(self)
                } else {
                    jsonData = data
                    break keyPathCheck
                }
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    throw MoyaError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(DecodableWrapper<D>.self, from: wrappedJsonData).value
                } catch let error {
                    throw MoyaError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            if jsonData.count < 1 && !failsOnEmptyData {
                if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONObjectData) {
                    return emptyDecodableValue
                } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONArrayData) {
                    return emptyDecodableValue
                }
            }
            return try decoder.decode(D.self, from: jsonData)
        } catch let error {
            throw MoyaError.objectMapping(error, self)
        }
    }
}


private struct DecodableWrapper<T: Decodable>: Decodable {
let value: T
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    
    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    func mapQueryString<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { .just(try $0.mapQueryString(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}




extension String {

    var parametersFromQueryString: [String: String] {
        return dictionaryBySplitting("&", keyValueSeparator: "=")
    }

    /// Encodes url string making it ready to be passed as a query parameter. This encodes pretty much everything apart from
    /// alphanumerics and a few other characters compared to standard query encoding.
    var urlEncoded: String {
        let customAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }

    var urlQueryEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }

    /// Returns new url query string by appending query parameter encoding it first, if specified.
    func urlQueryByAppending(parameter name: String, value: String, encode: Bool = true, _ encodeError: ((String, String) -> Void)? = nil) -> String? {
        if value.isEmpty {
            return self
        } else if let value = encode ? value.urlQueryEncoded : value {
            return "\(self)\(self.isEmpty ? "" : "&")\(name)=\(value)"
        } else {
            encodeError?(name, value)
            return nil
        }
    }

    /// Returns new url string by appending query string at the end.
    func urlByAppending(query: String) -> String {
        return "\(self)\(self.contains("?") ? "&" : "?")\(query)"
    }

    fileprivate func dictionaryBySplitting(_ elementSeparator: String, keyValueSeparator: String) -> [String: String] {
        var string = self

        if hasPrefix(elementSeparator) {
            string = String(dropFirst(1))
        }

        var parameters = [String: String]()

        let scanner = Scanner(string: string)

        var key: NSString?
        var value: NSString?

        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo(keyValueSeparator, into: &key)
            scanner.scanString(keyValueSeparator, into: nil)

            value = nil
            scanner.scanUpTo(elementSeparator, into: &value)
            scanner.scanString(elementSeparator, into: nil)

            if let key = key as String? {
                if let value = value as String? {
                    if key.contains(elementSeparator) {
                        var keys = key.components(separatedBy: elementSeparator)
                        if let key = keys.popLast() {
                            parameters.updateValue(value, forKey: String(key))
                        }
                        for flag in keys {
                            parameters.updateValue("", forKey: flag)
                        }
                    } else {
                        parameters.updateValue(value, forKey: key)
                    }
                } else {
                    parameters.updateValue("", forKey: key)
                }
            }
        }

        return parameters
    }

    var safeStringByRemovingPercentEncoding: String {
        return self.removingPercentEncoding ?? self
    }

    mutating func dropLast() {
        self.remove(at: self.index(before: self.endIndex))
    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String.Encoding {

    var charset: String {
        let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.rawValue))
         // swiftlint:disable:next force_cast superfluous_disable_command
        return charset! as String
    }

}
