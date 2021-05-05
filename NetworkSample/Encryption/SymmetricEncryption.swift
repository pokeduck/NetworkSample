//
// Symmetric Encryption.swift
//
// Created by Ben for NetworkSample on 2021/5/3.
// Copyright © 2021 Alien. All rights reserved.
//

import CryptoSwift

class SymmetricEncryption {
    /// PHP Option 0 or 1 or 2
    enum Option {
        case pkcs7 // php option 1
        case pkcs7Base64Encode // php option 0
        case zeroPaddingBase64Encode // phpiotion 2
    }
    func encrypt(key: String, data: String, option: Option = .pkcs7) -> String {
        let separator = "::".bytes
        let iv = AES.randomIV(AES.blockSize)
        let keyBytes = key.bytes
        let payload = data.bytes
        do {
            let padding: Padding = (option == .zeroPaddingBase64Encode) ? .zeroPadding : .pkcs7
            let aesConveter = try AES(key: keyBytes, blockMode: CBC(iv: iv), padding: padding)

            let encryptDataArray = try aesConveter.encrypt(payload)
            
            var combineData = [UInt8]()
            switch option {
            case .pkcs7:
                combineData = encryptDataArray + separator + iv
            case .pkcs7Base64Encode,.zeroPaddingBase64Encode:
                combineData = Data(encryptDataArray).base64EncodedData().bytes + separator + iv
            }
            
            
            
            let encrpyData = Data(combineData)
            let result = encrpyData.base64EncodedString()
            return result
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    func decrypt(key: String, data: String, option: Option = .pkcs7) -> String {
        guard let base64Data = Data(base64Encoded: data) else { return "" }
        guard let sepatator = "::".data(using: .utf8) else { return "" }
        let dataList = base64Data.split(separator: sepatator)
        guard let encryptedData = dataList.first,
              let iv = dataList.last
        else { return "" }
        var encryptedBytes = [UInt8]()
        
        switch option {
        case .pkcs7:
            encryptedBytes = encryptedData.bytes
        case .pkcs7Base64Encode,.zeroPaddingBase64Encode:
            guard let encryptedDataBase64Decode = Data(base64Encoded: encryptedData) else { return "" }
            encryptedBytes = encryptedDataBase64Decode.bytes
        }
        
        let ivBytes = iv.bytes
        let keyBytes = key.bytes
        
        do {
            let padding: Padding = (option == .zeroPaddingBase64Encode) ? .zeroPadding : .pkcs7
            let aesConveter = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: padding)

            let decryptBytes = try aesConveter.decrypt(encryptedBytes)
            let resultData = Data(decryptBytes)
            let resultString = String(data: resultData, encoding: .utf8)
            
            return resultString ?? ""
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    func test() {
        let key = String.randomMD5()
        let data = "PassPWDAABCD"
        let enc = encrypt(key: key, data: data, option: .zeroPaddingBase64Encode)
        let dec = decrypt(key: key, data: enc, option: .zeroPaddingBase64Encode)
        print(key)
        print(enc)
        print(dec)
    }
}
extension String {
    static func randomMD5() -> String {
        String.random(ofLength: 16).bytes.md5().toHexString()
    }
}
extension Data {
    //reference:https://stackoverflow.com/a/50476676/9186699
    fileprivate func split(separator: Data) -> [Data] {
        var chunks: [Data] = []
        var pos = startIndex
        // Find next occurrence of separator after current position:
        while let r = self[pos...].range(of: separator) {
            // Append if non-empty:
            if r.lowerBound > pos {
                chunks.append(self[pos..<r.lowerBound])
            }
            // Update current position:
            pos = r.upperBound
        }
        // Append final chunk, if non-empty:
        if pos < endIndex {
            chunks.append(self[pos..<endIndex])
        }
        return chunks
    }
}
