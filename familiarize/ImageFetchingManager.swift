//
//  ImageFetchingManager.swift
//  familiarize
//
//  Created by Alex Oh on 7/12/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import UIKit

class ImageFetchingManager {

    static func fetchImages(withSocialMediaInputs socialMediaInputs: [SocialMedia], completionHandler: @escaping ([UIImage]) -> Void) {
        let asyncDispatchGroup = DispatchGroup()
        var socialMediaProfileImages: [UIImage] = []
        for eachSocialMediaInput in socialMediaInputs {
            asyncDispatchGroup.enter()
            scrapeSocialMedia(withSocialMediaInput: eachSocialMediaInput, completionHandlerForScrape: { profileImage in
                
                    // TODO: Handle cases for when a profile image is not retrievable.
                    socialMediaProfileImages.append(profileImage)
                    asyncDispatchGroup.leave()
            })
        }
        
        asyncDispatchGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(socialMediaProfileImages)
        })
    }
    
    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    static func scrapeSocialMedia(withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForScrape: @escaping (UIImage) -> Void) {
        // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
        if socialMediaInput.appName == "faceBookProfile" {
            Alamofire.request("https://www.facebook.com/" + socialMediaInput.inputName!).responseString { response in
                if let html = response.result.value {
                    self.parseHTML(html: html, forSocialMediaApp: socialMediaInput.appName!, completionHandlerForParse: { profileImage in
                        completionHandlerForScrape(profileImage)
                    })
                }
            }
        }
    }
    
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    static func parseHTML(html: String, forSocialMediaApp socialMediaAppName: String, completionHandlerForParse: @escaping (UIImage) -> Void) {
        if socialMediaAppName == "faceBookProfile" {
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                for show in doc.css("img[class^='profilePic img']") {
                    let profileImageUrl = URL(string: show["src"]!)
                    URLSession.shared.dataTask(with: profileImageUrl!, completionHandler: { data, response, error in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let profileImageData = data {
                            completionHandlerForParse(UIImage(data: profileImageData)!)
                        }

                    }).resume()
                }
            }
        }
    }
}







