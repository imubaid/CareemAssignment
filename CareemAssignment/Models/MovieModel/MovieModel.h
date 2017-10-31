//
//  MovieModel.h
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 30/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface MovieModel : JSONModel
/*
 {
 "vote_count": 2131,
 "id": 268,
 "video": false,
 "vote_average": 7,
 "title": "Batman",
 "popularity": 17.022445,
 "poster_path": "/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg",
 "original_language": "en",
 "original_title": "Batman",
 "genre_ids": [
 14,
 28
 ],
 "backdrop_path": "/2blmxp2pr4BhwQr74AdCfwgfMOb.jpg",
 "adult": false,
 "overview": "The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker, who has seized control of Gotham's underworld.",
 "release_date": "1989-06-23"
 }*/
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *poster_path;
@property (nonatomic) NSString *overview;
@property (nonatomic) NSString *release_date;


@end
