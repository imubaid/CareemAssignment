//
//  MoviesRequestHandler.m
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 30/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import "MoviesRequestHandler.h"
#import "BaseHttpClient.h"
#import "BaseApiConstants.h"
@implementation MoviesRequestHandler

static MoviesRequestHandler *_obj;
+(instancetype)sharedInstance{
    if(!_obj){
        _obj = [[MoviesRequestHandler alloc]init];
    }
    
    @synchronized(_obj){
        return _obj;
    }
}

-(void)getMoviesWithQuery:(NSString*)query andPage:(int)page
                  success:(void(^)(NSArray<MovieModel*> *fetchedArray,BOOL canFetchMore))successHandler
                     fail:(void(^)(NSString *error))failHandler{
    @try{
        NSDictionary *parameters = @{
                                     @"api_key":kApiKey,
                                     @"query":query,
                                     @"page":@(page)
                                     };
        
        BaseHttpClient *httpClient = [BaseHttpClient new];
        [httpClient makeHttpRequestInJsonEncoding:kGetSearchApi requestMethod:@"GET" requestHeaders:nil requestParameters:parameters successCallback:^(id responseObject) {
            
            NSNumber *totalPages = (NSNumber*)responseObject[@"total_pages"];
            BOOL canFetchMore = YES;
            
            if(!totalPages.intValue > page){
                canFetchMore = NO;
            }
            
            NSMutableArray<MovieModel*> *finalArr = [NSMutableArray new];
            NSArray *results = (NSArray*)responseObject[@"results"];
            
            if(results == nil || [results isKindOfClass:[NSNull class]] || results.count == 0){
                successHandler(finalArr,canFetchMore);
            }
            
            for(NSDictionary *m in results){
                NSError *err = nil;
                MovieModel *movie = [[MovieModel alloc]initWithDictionary:m error:&err];
                if(!err){
                    [finalArr addObject:movie];
                }
            }
            
            successHandler(finalArr,canFetchMore);
            
        } failCallback:^(NSError *error, id responseObject) {
            failHandler(error.localizedDescription);
        } exceptionCallback:^(NSException *exception) {
            failHandler(exception.reason);
        }];
    }@catch(NSException *ex){
        failHandler(ex.reason);
    }
}

@end
