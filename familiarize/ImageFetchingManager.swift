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

    // TODO: Migrate everything from urlsession to alamofire.
    static func fetchImages(withSocialMediaInputs socialMediaInputs: [SocialMedia], completionHandler: @escaping ([SocialMediaProfileImage]) -> Void) {
        let asyncDispatchGroup = DispatchGroup()
        var socialMediaProfileImages: [SocialMediaProfileImage] = []
        for eachSocialMediaInput in socialMediaInputs {
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
            completionHandler(socialMediaProfileImages)
        })
    }

    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    static fileprivate func scrapeSocialMedia(withSocialMediaInput socialMediaInput: SocialMedia, completionHandlerForScrape: @escaping (SocialMediaProfileImage?) -> Void) {
        if socialMediaInput.appName == "faceBookProfile" {
            Alamofire.request("https://www.facebook.com/" + socialMediaInput.inputName!).responseString { response in
                if let html = response.result.value {
                    self.parseHTML(html: html, withSocialMediaInput: socialMediaInput, completionHandlerForParse: { profileImage in
                        completionHandlerForScrape(profileImage)
                    })
                } else {
                    // If the cancel button has been pressed or url was invalid, then dont return anything
                    completionHandlerForScrape(nil)
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
                } else {
                    // If the cancel button has been pressed or url was invalid, then dont return anything
                    completionHandlerForScrape(nil)
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
                    let profileImageUrl = "https://graph.facebook.com/\(facebook_id!)/picture?width=1080&height=1080"
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
                    // If the cancel button has been pressed or url was invalid, then dont return anything
                    completionHandlerForParse(nil)
                }
            }
        }
    }
    
    // Only fetch images from social media that has profile images.
    static func selectSocialMediaInputsWithPossibleImages (_ socialMediaInputs: [SocialMedia]) -> [SocialMedia] {
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
    
    static func cancelImageFetching() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
        URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
    }
    
    static func generateQRCode(uniqueID: UInt64, completionHandler: @escaping (Data?) -> Void) {
        let httpURL: String = "https://qrcode-monkey.p.mashape.com/qr/custom"
        let httpHeader: HTTPHeaders = [
            "X-Mashape-Key": "KT41kN7vl7mshiGSRoAZ3gU2UZpIp1dT1vgjsnqHC0CQqRL0ys",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let httpBody: Parameters = [
            "data": uniqueID,
            "config": [
                "body": "circle-zebra-vertical",
                "eye": "frame13",
                "eyeBall": "ball15",
                "erf1": [],
                "erf2": [],
                "erf3": [],
                "brf1": [],
                "brf2": [],
                "brf3": [],
                "bodyColor": "#0277BD",
                "bgColor": "#FFFFFF",
                "eye1Color": "#075685",
                "eye2Color": "#075685",
                "eye3Color": "#075685",
                "eyeBall1Color": "#0277BD",
                "eyeBall2Color": "#0277BD",
                "eyeBall3Color": "#0277BD",
                "gradientColor1": "#075685",
                "gradientColor2": "#0277BD",
                "gradientType": "linear",
                "gradientOnEyes": false,
                "logo": "#facebook"
            ],
            "size": 300,
            "download": false,
            "file": "png"
        ]
        
        Alamofire.request(httpURL, method: .post, parameters: httpBody, encoding: JSONEncoding.default, headers: httpHeader).responseData(completionHandler: { (responseData) in
            if let data = responseData.result.value {
                completionHandler(data)
//                let image = UIImage(data: data)
//                let imageView = UIImageView(image: image)
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                self.view.addSubview(imageView)
//                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//                imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            } else {
                completionHandler(nil)
            }
            
        })
    }
}







