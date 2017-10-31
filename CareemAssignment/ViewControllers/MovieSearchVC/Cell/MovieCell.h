//
//  MovieCell.h
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMovieCellIdentifier @"movie_cell"

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelOverview;
@property (weak, nonatomic) IBOutlet UILabel *labelReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMovieName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;

@end
