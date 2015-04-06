//
//  SecondViewController.h
//  PupsBook
//
//  Created by GRIFFIN on 13/02/14.
//  Copyright (c) 2014 GRIFFIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;
@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain) NSArray *arrImage;
@end
