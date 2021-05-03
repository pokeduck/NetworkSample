//
// Symmetric Encryption.swift
//
// Created by Ben for NetworkSample on 2021/5/3.
// Copyright © 2021 Alien. All rights reserved.
//

import CryptoSwift

class SymmetricEncryption {
    func encrypt(key: String, data: String) -> String {
        let separator = "::".bytes
        let iv = AES.randomIV(AES.blockSize)
        let keyBytes = key.bytes
        let payload = data.bytes
        do {
            let aesConveter = try AES(key: keyBytes, blockMode: CBC(iv: iv), padding: .pkcs7)

            let encryptDataArray = try aesConveter.encrypt(payload)
            
            let combineData = Data(encryptDataArray).base64EncodedData().bytes + separator + iv
            
            let encrpyData = Data(combineData)
            let result = encrpyData.base64EncodedString()
            return result
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    func decrypt(key: String, data: String) -> String {
        guard let base64Data = Data(base64Encoded: data) else { return "" }
        guard let sepatator = "::".data(using: .utf8) else { return "" }
        let dataList = base64Data.split(separator: sepatator)
        guard let encryptedData = dataList.first,
              let iv = dataList.last,
              let encryptedDataBase64Decode = Data(base64Encoded: encryptedData)
        else { return "" }
        
        let encryptedBytes = encryptedDataBase64Decode.bytes
        
        let ivBytes = iv.bytes
        let keyBytes = key.bytes
        
        do {
            let aesConveter = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7)

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
        let enc = encrypt(key: key, data: data)
        let dec = decrypt(key: key, data: enc)
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
