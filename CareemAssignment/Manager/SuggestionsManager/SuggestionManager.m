//
//  SuggestionManager.m
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import "SuggestionManager.h"
#define kStoredSuggestionKey @"saved_suggestions"
@implementation SuggestionManager

static SuggestionManager *_manger;
+(instancetype)sharedInstance{
    if(!_manger){
        _manger = [[SuggestionManager alloc]init];
    }
    
    @synchronized(_manger){
        return _manger;
    }
}

-(NSArray<NSString*>*)getLastSuggestions{
    NSMutableArray<NSString*> *suggestions = (NSMutableArray<NSString*>*) [[NSUserDefaults standardUserDefaults]valueForKey:kStoredSuggestionKey];
    if(suggestions){
        return suggestions;
    }else{
        suggestions = [NSMutableArray new];
        return suggestions;
    }
}

-(void)addSuccessSuggestion:(NSString*)text{
    NSMutableArray<NSString*> *suggestions = (NSMutableArray<NSString*>*) [[NSUserDefaults standardUserDefaults]valueForKey:kStoredSuggestionKey];
    
    if(suggestions){
        suggestions = [suggestions mutableCopy];
        
        BOOL isAlreadyAdded = NO;
        
        for(NSString *string in suggestions){
            if([string isEqualToString:text]){
                isAlreadyAdded = YES;
                break;
            }
        }
        
        if(isAlreadyAdded){
            return;
        }
        
        if(suggestions.count == 10){
            //remove first
            [suggestions removeObjectAtIndex:0];
        }
        
        [suggestions addObject:text];
        
    }else{
        suggestions = [NSMutableArray new];
        [suggestions addObject:text];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:suggestions forKey:kStoredSuggestionKey];
}

@end
