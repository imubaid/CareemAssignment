//
//  MovieCell.m
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
