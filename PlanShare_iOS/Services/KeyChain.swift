////
////  StorageManager.swift
////  PlanShare_iOS
////
////  Created by doyun on 2022/03/02.
////
//
//import Foundation
//import Security
//final class KeyChain {
//    
//    static let shared = KeyChain()
//    
//    private init(){ }
//    
//    private let account = "accessToken"
//    
//    private let service = Bundle.main.bundleIdentifier
//    
//    private lazy var query: [CFString: Any]? = {
//        guard let service = self.service else { return nil }
//        return [kSecClass: kSecClassGenericPassword,
//          kSecAttrService: service,
//          kSecAttrAccount: account]
//    }()
//    
//    func create(_ token: String) {
//        
//        guard let service = self.service else { return }
//        
//        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
//                             kSecAttrService: service,
//                             kSecAttrAccount: account,
//                             kSecAttrGeneric: token.data(using: .utf8, allowLossyConversion: false)!
//        ]
//        
//        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
//        assert(status == noErr, "fail to saving Token")
//    }
//    
//    func read() {
//        
//        guard let service = self.service else { return }
//        
//        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
//                                kSecAttrService: service,
//                                kSecAttrAccount: account,
//                                 kSecMatchLimit: kSecMatchLimitOne,
//                           kSecReturnAttributes: true,
//                                 kSecReturnData: true]
//        
//        var item: CFTypeRef?
//        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return  }
//        
//        guard let existingItem = item as? [CFString: Any],
//              let data = existingItem[kSecAttrGeneric] as? Data,
//              let token = try? JSONDecoder().decode(String.self, from: data) else { return  }
//        print(token)
//        
//        //      return user
//    }
//    
//    func update(_ token: String) -> Bool {
//        guard let query = self.query else { return false }
//        
//        let attributes: [CFString: Any] = [kSecAttrAccount: account,
//                                           kSecAttrGeneric: token]
//        
//        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
//    }
//    
//    func delete() -> Bool {
//        guard let query = self.query else { return false }
//        return SecItemDelete(query as CFDictionary) == errSecSuccess
//    }
//}
//
