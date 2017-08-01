//
//  Request.m
//  familiarize
//
//  Created by Daniel Park on 7/31/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNIRest.h"

// These code snippets use an open-source library. http://unirest.io/objective-c
NSDictionary *headers = @{@"X-Mashape-Key": @"ddkwc9CKTgmshWfrKQ88cgzM8JGhp1zqUEPjsnSNcuHuC6RQ1l", @"Content-Type": @"application/json", @"Accept": @"application/json"};
UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
    [request setUrl:@"https://qrcode-monkey.p.mashape.com/qr/custom"];
    [request setHeaders:headers];
    [request setBody:@"{\"data\":\"https://www.qrcode-monkey.com\",\"config\":{\"body\":\"circle-zebra-vertical\",\"eye\":\"frame13\",\"eyeBall\":\"ball15\",\"erf1\":[],\"erf2\":[],\"erf3\":[],\"brf1\":[],\"brf2\":[],\"brf3\":[],\"bodyColor\":\"#0277BD\",\"bgColor\":\"#FFFFFF\",\"eye1Color\":\"#075685\",\"eye2Color\":\"#075685\",\"eye3Color\":\"#075685\",\"eyeBall1Color\":\"#0277BD\",\"eyeBall2Color\":\"#0277BD\",\"eyeBall3Color\":\"#0277BD\",\"gradientColor1\":\"#075685\",\"gradientColor2\":\"#0277BD\",\"gradientType\":\"linear\",\"gradientOnEyes\":false,\"logo\":\"#facebook\"},\"size\":600,\"download\":false,\"file\":\"png\"}"];
}] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
    NSInteger code = response.code;
    NSDictionary *responseHeaders = response.headers;
    UNIJsonNode *body = response.body;
    NSData *rawBody = response.rawBody;
}];
