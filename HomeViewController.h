//
//  HomeViewController.h
//  PupsBook
//
//  Created by GRIFFIN on 13/02/14.
//  Copyright (c) 2014 GRIFFIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableData *data;
    NSString *documentsDirectory;
    

}
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *arrayName;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *ai;
@property(nonatomic,retain) NSString *str;
@property(nonatomic,retain)   NSArray *ary;
- (void)saveLocally:(NSData *)imgData name:(NSString *) receiveString;
@property(nonatomic,retain)NSMutableData *arrImg1;
@property(nonatomic,retain)  NSString *localFilePath;
@property(nonatomic,retain)  NSMutableArray *mdata;;

@end
