//
//  MoviewSearchVC.m
//  CareemAssignment
//
//  Created by Ubaid  ur Rahman on 31/10/2017.
//  Copyright © 2017 Ubaid  ur Rahman. All rights reserved.
//

#import "MoviewSearchVC.h"
#import "MovieCell.h"
#import "MovieModel.h"
#import "Constants.h"
#import "MoviesRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SuggestionManager.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
@interface MoviewSearchVC (){
    NSMutableArray<MovieModel*> *_movies;
    int currentPage;
    BOOL canFetchMore;
    BOOL isFetching;
    DGActivityIndicatorView *activityIndicatorView;
}
@end

@implementation MoviewSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentPage = 1;
    _movies = [NSMutableArray new];
    canFetchMore = YES;
    isFetching = NO;
    
    self.tableViewMovies.estimatedRowHeight = 150;
    self.tableViewMovies.rowHeight = UITableViewAutomaticDimension;
    
    self.tableViewMovies.delegate = self;
    self.tableViewMovies.dataSource = self;
    
    self.tableViewSuggestions.delegate = self;
    self.tableViewSuggestions.dataSource = self;
    
    //coner sides
    self.tableViewSuggestions.layer.cornerRadius = 10;
    self.tableViewSuggestions.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.8];
    
    self.textFieldSearch.delegate = self;
    
    //setup activity indicator
//    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor whiteColor] size:20.0f];
//    activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
//    [self.view addSubview:activityIndicatorView];
}

#pragma TABLE VIEW DELEGATE AND DATA SOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        return _movies.count;
    }else{
        return [[SuggestionManager sharedInstance]getLastSuggestions].count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1){
        //movies table view
        MovieCell *cell = (MovieCell*)[self.tableViewMovies dequeueReusableCellWithIdentifier:kMovieCellIdentifier];
    
        MovieModel *movie = [_movies objectAtIndex:indexPath.row];
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageUrl,movie.poster_path]];
        [cell.imageViewPoster sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
        cell.labelMovieName.text = movie.title;
        cell.labelReleaseDate.text = movie.release_date;
        cell.labelOverview.text = movie.overview;
    
        return cell;
    }else{
        //suggestion tableview
        NSString *text = [[[SuggestionManager sharedInstance]getLastSuggestions]objectAtIndex:indexPath.row];
        
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = text;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.backgroundColor =  [[UIColor blueColor]colorWithAlphaComponent:0.8];
        
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 2){
        //if suggestion table
        [self hideSuggestions];
        NSString *text = [[[SuggestionManager sharedInstance]getLastSuggestions]objectAtIndex:indexPath.row];
        currentPage = 1;
        [_movies removeAllObjects];
        [self getMoviesListWithText:text andPage:currentPage];
        self.textFieldSearch.text = text;
    }
}

-(void)showSuggestions{
    [UIView animateWithDuration:0.35 animations:^{
        self.suggestionTopYConstraint.constant = 4;
        [self.view layoutIfNeeded];
    }];
}

-(void)hideSuggestions{
    [UIView animateWithDuration:0.35 animations:^{
        self.suggestionTopYConstraint.constant = -300;
        [self.view layoutIfNeeded];
    }];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"decelerate %@",@(decelerate));
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBotom = scrollView.contentSize.height - contentYOffset;
    if(distanceFromBotom < height && canFetchMore == YES && isFetching == NO) {
        NSLog(@"scrolled to last , fetching for page %d",currentPage);
        [self getMoviesListWithText:self.textFieldSearch.text andPage:currentPage];
    }
    
}

#pragma TEXT FIELD DELEGATE
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideSuggestions];
    [textField resignFirstResponder];
    currentPage = 1;
    [_movies removeAllObjects];
    [self getMoviesListWithText:textField.text andPage:currentPage];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self hideSuggestions];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Suggestions %@",[[SuggestionManager sharedInstance]getLastSuggestions]);
    
    if([[SuggestionManager sharedInstance] getLastSuggestions].count > 0){
        [self showSuggestions];
    }
}

#pragma API Request
-(void)getMoviesListWithText:(NSString*)text andPage:(int)page{
   // [activityIndicatorView startAnimating];
    isFetching = YES;
    [[MoviesRequestHandler sharedInstance]getMoviesWithQuery:text andPage:page success:^(NSArray<MovieModel *> *fetchedArray, BOOL fetchMore) {
        
    //    [activityIndicatorView stopAnimating];
        
        isFetching = NO;
        canFetchMore = fetchMore;
        
        if(fetchedArray.count == 0){
            NSLog(@"NO DATA");
            [self showAlertMessageWithTitle:@"NO Records" andMessage:[NSString stringWithFormat:@"No records found for movie name '%@'",text]];
            return;
        }else{
            currentPage++;// = page + 1;
        }
        
        for(MovieModel *movie in fetchedArray){
            [_movies addObject:movie];
        }
        
        [self.tableViewMovies reloadData];
        
        //adding as suggestion
        [[SuggestionManager sharedInstance]addSuccessSuggestion:text];
        [self.tableViewSuggestions reloadData];
    } fail:^(NSString *error) {
      //  [activityIndicatorView stopAnimating];
        NSLog(@"API ERROR : %@",error);
         isFetching = NO;
        [self showAlertMessageWithTitle:@"Fetch Error" andMessage:@"Something went wrong with fetching. Please try again."];
    }];
}

#pragma SHOW ALERT MESSAGE

-(void)showAlertMessageWithTitle:(NSString *)title andMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
@end
