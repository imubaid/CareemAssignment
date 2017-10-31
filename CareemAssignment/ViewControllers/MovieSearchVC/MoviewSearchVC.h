//
//  MoviewSearchVC.h
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviewSearchVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMovies;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSuggestions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionTopYConstraint;

@end
