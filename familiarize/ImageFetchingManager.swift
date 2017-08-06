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
    
        // USE OPERATIONQUEUE IN ORDER TO CANCEL ALL QUEUES!!!
        let asyncDispatchGroup = DispatchGroup()
        var socialMediaProfileImages: [SocialMediaProfileImage] = []
        let massagedSocialMediaInputs = massageSocialMediaInputsData(socialMediaInputs)
        for eachSocialMediaInput in massagedSocialMediaInputs {
            asyncDispatchGroup.enter()
            scrapeSocialMedia(withSocialMediaInput: eachSocialMediaInput, completionHandlerForScrape: { profileImage in
                    // TODO: Handle cases for when a profile image is not retrievable.
                if profileImage != nil {
                    socialMediaProfileImages.append(profileImage!)
                }
                asyncDispatchGroup.leave()
            })
        }
        
        asyncDispatchGroup.notify(queue: DispatchQueue.main, execute: {
            let defaultSocialMediaInput : SocialMedia = SocialMedia(withAppName: "default", withImageName: "default", withInputName: "default", withAlreadySet: false)
            let defaultSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: defaultSocialMediaInput, withImage: UIImage(named: "dan_camera_85")!)
            socialMediaProfileImages.append(defaultSocialMediaProfileImage)
            completionHandler(socialMediaProfileImages)
        })
    }
    
    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    static fileprivate func scrapeSocialMedia(withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForScrape: @escaping (SocialMediaProfileImage?) -> Void) {
        // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
        if socialMediaInput.appName == "faceBookProfile" {
        
            Alamofire.request("https://www.facebook.com/" + socialMediaInput.inputName!).responseString { response in
                
                if let html = response.result.value {
                    self.parseHTML(html: html, withSocialMediaInput: socialMediaInput, completionHandlerForParse: { profileImage in
                        completionHandlerForScrape(profileImage)
                    })
                }

            }
        } else if socialMediaInput.appName == "default" {
            let formattedProfileImageURL  = URL(string: socialMediaInput.inputName!)
            URLSession.shared.dataTask(with: formattedProfileImageURL!, completionHandler: { data, response, error in
                
                if let profileImageData = data {
                    DispatchQueue.main.async {
                        
                        let newSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: socialMediaInput, withImage: UIImage(data: profileImageData)!)
                        completionHandlerForScrape(newSocialMediaProfileImage)
                    }
                }
            }).resume()
        }
    }
    
    //https://www.techuntold.com/view-instagram-profile-picture-full-size/
    //https://gist.github.com/jcsrb/1081548
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    static fileprivate func parseHTML(html: String, withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForParse: @escaping (SocialMediaProfileImage?) -> Void) {
        if socialMediaInput.appName == "faceBookProfile" {
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                if let show = doc.at_css("meta[property^='al:ios:url']") {
                    let facebook_url = show["content"]?.components(separatedBy: "/")
                    let facebook_id = facebook_url?[3]
                    let profileImageUrl = "http://graph.facebook.com/\(facebook_id!)/picture?width=1080&height=1080"
                    let formattedProfileImageUrl  = URL(string: profileImageUrl)
                    URLSession.shared.dataTask(with: formattedProfileImageUrl!, completionHandler: { data, response, error in
                        
                        if let profileImageData = data {
                            
                            DispatchQueue.main.async {
                                let newSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: socialMediaInput, withImage: UIImage(data: profileImageData)!)
                                completionHandlerForParse(newSocialMediaProfileImage)
                            }
                        }

                    }).resume()
                } else {
                    completionHandlerForParse(nil)
                }
            }
        }
    }
    
    // Only fetch images from social media that has profile images.
    static fileprivate func massageSocialMediaInputsData(_ socialMediaInputs: [SocialMedia]) -> [SocialMedia] {
        var massagedSocialMediaInputs: [SocialMedia] = []
        
        // TODO: Include all social media that supports profile images.
        let socialMediaAppsWithRetrievableProfileImages: Set<String> = ["faceBookProfile", "default"]
        
        for eachSocialMediaInput in socialMediaInputs {
            if socialMediaAppsWithRetrievableProfileImages.contains(eachSocialMediaInput.appName!) {
                massagedSocialMediaInputs.append(eachSocialMediaInput)
            }
        }
        return massagedSocialMediaInputs
    }
}







