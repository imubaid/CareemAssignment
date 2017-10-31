//
//  BaseHttpClient.m
//  BaseApplicationFlow
//
//  Created by Ubaid  ur Rahman on 07/12/2016.
//  Copyright © 2016 Ubaid  ur Rahman. All rights reserved.
//

#import "BaseHttpClient.h"
#import "BaseApiConstants.h"

@implementation BaseHttpClient


-(void)makeHttpRequestInFormEncoding:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                    requestParameters:(NSDictionary*)parameters
                    successCallback:(Request_Success_Block) success
                    failCallback:(Request_Error_Block) fail
                    exceptionCallback:(Request_Exception_Block)exception{
    @try {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //set serializer
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        //prepare url
        NSString *url = [self getUrl:partialUrl];
        //get mutable url request
        NSMutableURLRequest *request = [self getRequestForFormEncoding:url requestMethod:method requestHeaders:headers requestParameters:parameters];
        //make data task with request
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"HTTP_ERROR: %@", error);
                NSLog(@"HTTP_ERROR_RESPONSE: %@", responseObject);
                fail(error,responseObject);
            } else {
                NSLog(@"HTTP_RESPONSE : %@",responseObject);
                success(responseObject);
            }
        }];
        //make http request
        [dataTask resume];
    } @catch (NSException *ex) {
        NSLog(@"HTTP_EXCEPTION_NAME : %@",ex.name);
        NSLog(@"HTTP_EXCEPTION_REASON : %@",ex.reason);
        exception(ex);
    }
}


-(void)makeHttpRequestInJsonEncoding:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                   requestParameters:(NSDictionary*)parameters
                     successCallback:(Request_Success_Block) success
                        failCallback:(Request_Error_Block) fail
                   exceptionCallback:(Request_Exception_Block)exception{
    @try {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //set serializer
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        //prepare url
        NSString *url = [self getUrl:partialUrl];
        //get mutable url request
        NSMutableURLRequest *request = [self getRequestForJsonEncoding:url requestMethod:method requestHeaders:headers requestParameters:parameters];
        //log request
        NSLog(@"REQUEST_OBJ : %@",request);
        //make data task with request
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"HTTP_ERROR: %@", error);
                NSLog(@"HTTP_ERROR_RESPONSE: %@", responseObject);
                fail(error,responseObject);
            } else {
                NSLog(@"HTTP_RESPONSE : %@",responseObject);
                success(responseObject);
            }
        }];
        //make http request
        [dataTask resume];
    } @catch (NSException *ex) {
        NSLog(@"HTTP_EXCEPTION_NAME : %@",ex.name);
        NSLog(@"HTTP_EXCEPTION_REASON : %@",ex.reason);
        exception(ex);
    }

    
}

-(void)makeHttpMultiPartRequest:(NSString*)partialUrl requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
              requestParameters:(NSDictionary*)parameters
                fileData:(NSData*)fileData
                       fileName:(NSString*)fileName
              fileParametername:(NSString*)parameterName
                       mimeType:(NSString*)mimeType
                successCallback:(Request_Success_Block) success
                   failCallback:(Request_Error_Block) fail
              exceptionCallback:(Request_Exception_Block)exception{
    @try {
        NSString *url = [self getUrl:partialUrl];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //[formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:parameterName fileName:fileName mimeType:mimeType error:nil];
            [formData appendPartWithFileData:fileData name:parameterName fileName:fileName mimeType:mimeType];
            
            //adding other parameters if not nil
            if(parameters != nil){
                for(NSString* key in parameters){
                    [formData appendPartWithFormData:[parameters objectForKey:key] name:key];
                }
            }

        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        //adding headers if exist
        if(headers != nil){
            for(NSString* key in headers){
                [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        //adding other parameters if not nil
//        if(parameters != nil){
//            for(NSString* key in parameters){
//                [request setValue:[parameters objectForKey:key] forKey:key];
//            }
//        }
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          //to show upload progess
                          //can be used to display progess on UI but should be call on main thread otherwise application will be crashed
                          NSLog(@"percentage uploaded : %f",uploadProgress.fractionCompleted);
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"HTTP_ERROR: %@", error);
                              NSLog(@"HTTP_ERROR_RESPONSE: %@", responseObject);
                              fail(error,responseObject);
                          } else {
                              NSLog(@"HTTP_RESPONSE : %@",responseObject);
                              success(responseObject);
                          }
                      }];
        
        [uploadTask resume];
    }@catch (NSException *ex) {
        NSLog(@"HTTP_EXCEPTION_NAME : %@",ex.name);
        NSLog(@"HTTP_EXCEPTION_REASON : %@",ex.reason);
        exception(ex);
    }

}



-(NSString*)getUrl:(NSString*)partialUrl{
    return [NSString stringWithFormat:@"%@%@",kBaseUrl,partialUrl];
}

-(NSMutableURLRequest*)getRequestForFormEncoding:(NSString*)url requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                                  requestParameters:(NSDictionary*)parameters{
    //check if parameters is nil then init with empty dictionary
    if(parameters == nil){
        parameters = @{};
    }
    
    NSMutableURLRequest *request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:parameters error:nil];
    
    //add headers if not nil
    if(headers != nil){
        for(NSString* key in headers){
        [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    return request;
}

-(NSMutableURLRequest*)getRequestForJsonEncoding:(NSString*)url requestMethod:(NSString*)method requestHeaders:(NSDictionary*)headers
                               requestParameters:(NSDictionary*)parameters{
    //check if parameters is nil then init with empty dictionary
    if(parameters == nil){
        parameters = @{};
    }
    
    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:url parameters:parameters error:nil];
    
    //add headers if not nil
    if(headers != nil){
        for(NSString* key in headers){
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    return request;
}



@end
