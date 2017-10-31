//
//  BaseHttpClient.h
//  BaseApplicationFlow
//
//  Created by Ubaid  ur Rahman on 07/12/2016.
//  Copyright © 2016 Ubaid  ur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface BaseHttpClient : NSObject

typedef void (^Request_Success_Block) (id responseObject);
typedef void (^Request_Error_Block) (NSError *error , id responseObject);
typedef void (^Request_Exception_Block) (NSException *exception);

-(void)makeHttpRequestInFormEncoding:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                        requestParameters:(NSDictionary*)parameters
                        successCallback:(Request_Success_Block) success
                        failCallback:(Request_Error_Block) fail
                        exceptionCallback:(Request_Exception_Block)exception;

-(void)makeHttpRequestInJsonEncoding:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                   requestParameters:(NSDictionary*)parameters
                     successCallback:(Request_Success_Block) success
                        failCallback:(Request_Error_Block) fail
                   exceptionCallback:(Request_Exception_Block)exception;


-(void)makeHttpMultiPartRequest:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
              requestParameters:(NSDictionary*)parameters
                       fileData:(NSData*)fileData
                       fileName:(NSString*)fileName
              fileParametername:(NSString*)parameterName
                       mimeType:(NSString*)mimeType
                successCallback:(Request_Success_Block) success
                   failCallback:(Request_Error_Block) fail
              exceptionCallback:(Request_Exception_Block)exception;


@end
