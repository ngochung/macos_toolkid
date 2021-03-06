//
//  ConnectLogin.swift
//  ToolKids
//
//  Created by hungdn on 9/21/17.
//  Copyright © 2017 Doan Ngoc Hung. All rights reserved.
//

import Foundation
import SharkORM
import CryptoSwift

class Unit_tool : Any {
    
    func getoffset(FACTORY_KEY : String) -> Int {
        return Int(arc4random_uniform(UInt32(FACTORY_KEY.characters.count)))
    }
    
    func getkey(FACTORY_KEY : String, offset : Int) -> String{
        let index1 = FACTORY_KEY.index(FACTORY_KEY.startIndex, offsetBy: offset)
        
        
        let substring1 = FACTORY_KEY.substring(to: index1)
        print("substring1:  " + substring1)
        
        let substring2 = FACTORY_KEY.substring(from: index1)
        print("substring2:  " + substring2)
        
        let key_firt : String! = String(substring2 + substring1)
        let index3 = key_firt.index(key_firt.startIndex, offsetBy: 16)
        let key :String! = key_firt.substring(to: index3)
        
        return key
        
    }
    
    func getreq() -> String{
        let uuid = UUID().uuidString
        print("uuid:  " + uuid)
        
        let index2 = uuid.index(uuid.startIndex, offsetBy: 16)
        
        let req = uuid.substring(to: index2)
        
        return req
        
    }
    
    func Aes_encrypt(key: String, req :String) -> String {
        
        var aes_text : String? = ""
        
        do {
            let aes = try AES(key: key, iv: "", blockMode: .ECB, padding: NoPadding())
            let aes_req = try aes.encrypt([UInt8](req.utf8))
            aes_text = aes_req.toHexString()
            
            print("aes_text:  " +  aes_text!)
            
        } catch {
            
        }
        
        return aes_text!
    }
    
    func getHmac(FACTORY_KEY: String, req :String) -> String {
        var hmac_cal : String? = ""
        do {
            
            let hmac_req = try HMAC(key: FACTORY_KEY, variant: .sha1).authenticate([UInt8](req.utf8))
            hmac_cal = hmac_req.toHexString()
            print("hmac_cal:  " + hmac_cal!)
            
        } catch {
            
        }
        
        return hmac_cal!
    }
    
    func getT(FACTORY_KEY : String , key : String, req : String, offset : Int) -> String {
        let aes_text = Aes_encrypt(key: key, req: req)
        
        let hmac_cal = getHmac(FACTORY_KEY: FACTORY_KEY, req: req)
        print(aes_text + hmac_cal)
        return aes_text + hmac_cal
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        let str = text.replacingOccurrences(of: "\0\0\0\0\0\0\0\0\0", with: "")
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func Aes_decrypt(key : String, responseString : String) -> [UInt8] {
        var decrypted : [UInt8] = []
        do{
            let res_aes = try AES(key: key, iv: "", blockMode: .ECB, padding: NoPadding())
            let bytes = Array<UInt8>(hex: responseString)
            decrypted = try res_aes.decrypt(bytes)
            
        }catch{
            
        }
        
        return decrypted
    }
    
    func covertobjecttojson(device_info : Device_Info) -> String{
        var result : String? = ""
        var dict : Dictionary<String, Any> = [:]
        
        dict["ptuid"] = device_info.ptuid
        dict["akey"] = device_info.akey
        dict["sn"] = device_info.sn
        dict["imei"] = device_info.imei
        dict["iccid"] = device_info.imei
        dict["imsi"] = device_info.imei
        dict["rnd"] = device_info.rnd
        dict["mcc"] = device_info.mcc
        dict["mnc"] = device_info.mnc
        dict["cdma_tid"] = device_info.cdma_tid
        dict["uimid"] = device_info.uimid
        dict["esn"] = device_info.esn
        dict["meid"] = device_info.meid
        dict["area_code"] = device_info.area_code
        dict["iccid"] = device_info.iccid
        dict["imsi"] = device_info.imsi
        
        
        do{
            
            var error : NSError?
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            result = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            print("aaaaa" + result!)
            
        }catch{
            
        }
        return result!
    }
    func Aes_encrypt_genqr(key: String, req :String , iv : String) -> String {
        
        var aes_text : String? = ""
        
        do {
            let aes = try AES(key: key, iv: iv, blockMode: .CFB, padding: NoPadding.self as! Padding)
            let aes_req = try aes.encrypt([UInt8](req.utf8))
            aes_text = aes_req.toHexString()
            
            print("aes_text:  " +  aes_text!)
            
        } catch {
            
        }
        
        return aes_text!
    }
    
}
