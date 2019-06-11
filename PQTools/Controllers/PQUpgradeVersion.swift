

import UIKit

open class PQUpgradeVersion: NSObject {
    
    
    /// check app version
    ///
    /// - Parameters:
    ///   - completion: current version, CFBundleShortVersionString
    /// - Throws: catch some error
    public class func checkVersion(for appId: String?, completion: @escaping (String?, String?, Error?) -> ()) throws{
        guard let appId = appId, appId.count > 0 else  { print("PQUpgradeVersion: App id invalid"); return }
        
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=" + appId) else {
            throw (NSError(domain: "URL invalid", code: 0, userInfo: nil))
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completion(nil, nil, error)
                print("PQUpgradeVersion: ",error)
                return
            }
            
            let dict = Bundle.main.infoDictionary
            let version = dict?["CFBundleShortVersionString"] as? String
            
            if let data = data,
                let appMsg = String(data: data, encoding: .utf8),
                let appMsgDict = PQUpgradeVersion.getDictFromString(appMsg),
                let appResultsArray = (appMsgDict["results"] as? NSArray),
                let appResultsDict = appResultsArray.lastObject as? NSDictionary,
                let appStoreVersion = appResultsDict["version"] as? String
                {
                
                completion(appStoreVersion, version, nil)
            } else {
               let error = NSError(domain: "Parse data error", code: 0, userInfo: ["data": data ?? "nil"])
                completion(nil, version, error)
            }
        }).resume()
    }
    
    
    
    class func jumpToAppStore(appID: String) throws {
        
        guard let url = URL(string: "http://itunes.apple.com/app/id" + appID)  else {
            throw (NSError(domain: "URL invalid", code: 0, userInfo: nil) as Error)
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            throw (NSError(domain: "Can not open this url", code: 0, userInfo: nil) as Error)
        }
        
    }
    
    private class func getDictFromString(_ jsonString: String) -> [String: Any]? {
        
        if let jsonData = jsonString.data(using: .utf8) {
            
            if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
                
                return dict as? [String: Any]
            }
            return nil
        }
        return nil
    }
    
}



