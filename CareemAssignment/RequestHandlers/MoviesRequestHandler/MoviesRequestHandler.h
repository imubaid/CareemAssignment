//
//  MoviesRequestHandler.h
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 30/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"
@interface MoviesRequestHandler : NSObject

+(instancetype)sharedInstance;

-(void)getMoviesWithQuery:(NSString*)query andPage:(int)page
                  success:(void(^)(NSArray<MovieModel*> *fetchedArray,BOOL canFetchMore))successHandler
                     fail:(void(^)(NSString *error))failHandler;

@end
