//
//  SuggestionManager.h
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionManager : NSObject

+(instancetype)sharedInstance;

-(NSArray<NSString*>*)getLastSuggestions;

-(void)addSuccessSuggestion:(NSString*)text;

@end
