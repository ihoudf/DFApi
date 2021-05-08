//
//  ApiCache.swift
//  DFApi
//
//  Created by ihoudf on 2021/4/28.
//

import Foundation


private var ApiCacheUserId: String? {
    return nil
}

private func ApiDirPath() -> String? {
    let dir = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "") + "/ApiCache"
    if let userId = ApiCacheUserId {
        return dir + userId
    }
    return dir
}

private func ApiFilePath(for key: Api) -> String? {
    guard let dirPath = ApiDirPath() else { return nil }
    return dirPath + "/" + (key.path.replacingOccurrences(of: "/", with: "_"))
}


// MARK: - 存

func setCache(object: Data, for key: Api) {
    guard let dirPath = ApiDirPath(), let filePath = ApiFilePath(for: key) else {
        return
    }
    var isDir: ObjCBool = true
    if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) {
        try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
    }

    var isDir2: ObjCBool = false
    if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir2) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    let isSucc = FileManager.default.createFile(atPath: filePath, contents: object, attributes: nil)
    print((isSucc ? "保存成功" : "保存失败"))
}


// MARK: - 取

func getCache(for key: Api) -> Data? {
    guard let filePath = ApiFilePath(for: key) else { return nil }

    if FileManager.default.fileExists(atPath: filePath) {
        return try? Data(contentsOf: URL(fileURLWithPath: filePath), options: [.uncached])
    }

    return nil
}


// MARK: - 清除缓存

func clearCache(for key: Api? = nil) {
    
    guard let dirPath = ApiDirPath() else { return }
    guard let key = key else {
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) {
            try? FileManager.default.removeItem(atPath: dirPath)
        }
        return
    }
    
    if let filePath = ApiFilePath(for: key) {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
}
