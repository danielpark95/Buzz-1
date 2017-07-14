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

class ImageFetchingManager {

    static func fetchImages(withSocialMediaInputs socialMediaInputs: [SocialMedia], completionHandler: @escaping ([SocialMediaProfileImage]) -> Void) {
        let asyncDispatchGroup = DispatchGroup()
        var socialMediaProfileImages: [SocialMediaProfileImage] = []
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
    static func scrapeSocialMedia(withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForScrape: @escaping (SocialMediaProfileImage) -> Void) {
        // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
        if socialMediaInput.appName == "faceBookProfile" {
            Alamofire.request("https://www.facebook.com/" + socialMediaInput.inputName!).responseString { response in
                if let html = response.result.value {
                    self.parseHTML(html: html, withSocialMediaInput: socialMediaInput, completionHandlerForParse: { profileImage in
                        completionHandlerForScrape(profileImage)
                    })
                }
            }
        }
    }
    
//https://www.techuntold.com/view-instagram-profile-picture-full-size/
    //https://gist.github.com/jcsrb/1081548
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    static func parseHTML(html: String, withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForParse: @escaping (SocialMediaProfileImage) -> Void) {
        if socialMediaInput.appName == "faceBookProfile" {
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                for show in doc.css("meta[property^='al:ios:url']") {
                    let facebook_url = show["content"]?.components(separatedBy: "/")
                    let facebook_id = facebook_url?[3]
                    let profileImageUrl = "http://graph.facebook.com/\(facebook_id!)/picture?width=1080&height=1080"
                    
                    let formattedProfileImageUrl  = URL(string: profileImageUrl)
                    URLSession.shared.dataTask(with: formattedProfileImageUrl!, completionHandler: { data, response, error in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let profileImageData = data {
                            let newSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: socialMediaInput, withImage: UIImage(data: profileImageData)!)
                            completionHandlerForParse(newSocialMediaProfileImage)
                        }

                    }).resume()
                }
            }
        }
    }
}







