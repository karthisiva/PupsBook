//
//  HomeViewController.m
//  PupsBook
//
//  Created by GRIFFIN on 13/02/14.
//  Copyright (c) 2014 GRIFFIN. All rights reserved.
//

#import "HomeViewController.h"
#import "MyCell.h"
#import "SecondViewController.h"
#import <CommonCrypto/CommonDigest.h>
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize ai;
@synthesize str;
@synthesize ary;
@synthesize localFilePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    ai=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(130, 160, 50, 50)];
//    [self.view addSubview:ai];
    self.arrImg1=[[NSMutableData alloc]init];
    self.arrayName=[[NSMutableArray alloc]init];
        NSString *strUrl=[NSString stringWithFormat:@"http://www.pupsbook.com/m_.php?cmd=getFeed&offset=0&limit=100&userID=5&device=ios&status=active&latestDate="];
    NSURL *url=[NSURL URLWithString:strUrl];
        NSURLRequest *req=[NSURLRequest requestWithURL:url];
        NSURLConnection *con=[NSURLConnection connectionWithRequest:req delegate:self];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];

    
    if (con) {
    
            data=[[NSMutableData alloc]init];
//            NSLog(@"%@",data);
        }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.arrayName count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    MyCell *cell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:0];
       
    }
    NSDictionary *dci=[self.arrayName objectAtIndex:indexPath.row];
    cell.lblName.text=[dci valueForKey:@"fullName"];
    cell.lblLike.text=[dci valueForKey:@"likeCount"];
    cell.lblComment.text=[NSString stringWithFormat:@"%@",[dci valueForKey:@"commentCount"]];
    cell.lblShare.text=[NSString stringWithFormat:@"%@",[dci valueForKey:@"shareCount"]];
    
    
  //Synchronous Download:
//    NSURL *url1=[NSURL URLWithString:[dci valueForKey:@"uThumbPath"]];
//    NSData *data1=[NSData
//                   dataWithContentsOfURL:url1];
//    
//    cell.imgThumb.image=[UIImage imageWithData:data1];
//    
//    NSURL *url2=[NSURL URLWithString:[dci valueForKey:@"userImage"]];
//    NSData *data2=[NSData
//                   dataWithContentsOfURL:url2];
//    cell.imgUser.image=[UIImage imageWithData:data2];
   
    
    
    
// Asynchronous Download:
    NSString *strNew=[dci valueForKey:@"uThumbPath"];
    NSString *strCompare=[NSString stringWithFormat:@"%@.jpg",[self MD5String:strNew]];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",documentsPath);
    NSString *strFileName=[NSString stringWithFormat:@"%@/%@",documentsPath,strCompare];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:strFileName])
    {
        NSLog(@"Downloaded From Localpath");
        NSString *inputPath= strFileName;
        NSString *extension=[inputPath pathExtension];
        NSString *file=[[inputPath lastPathComponent]stringByDeletingPathExtension];
        NSString *dir=[inputPath stringByDeletingLastPathComponent];
        NSString *imagePATH=[NSBundle pathForResource:file ofType:extension inDirectory:dir];
       UIImage* theImage=[UIImage imageWithContentsOfFile:imagePATH];
        cell.imgThumb.image=theImage;
        
    }
    else{
        NSLog(@"Downloaded From Server");
        NSURL *URL = [NSURL URLWithString: [dci valueForKey:@"uThumbPath"]];
        NSURLRequest* request = [NSURLRequest requestWithURL:URL];
        NSLog(@"%@",strNew);
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data1,
                                                   NSError * error) {
                                   
                                   if (!error){
                                       
                                       [self saveLocally:data1 name:strNew];
                                       cell.imgThumb.image = [UIImage imageWithData:data1];
                                       
                                   }
                                   
                               }];

    }

    
    NSURL *URL2 = [NSURL URLWithString: [dci valueForKey:@"userImage"]];
    NSURLRequest* request2 = [NSURLRequest requestWithURL:URL2];
    
    
    [NSURLConnection sendAsynchronousRequest:request2
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * data2,
                                               NSError * error) {
                               if (!error){
                                   cell.imgUser.image = [UIImage imageWithData:data2];
                                 
                               }
                               
                           }];
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//        
//        NSData *imageData ;
//        NSURL *url=[NSURL URLWithString:[dci valueForKey:@"userImage"]];
//        NSLog(@"%@",url);
//        imageData = [NSData dataWithContentsOfURL:url];
//        
//        dispatch_sync(dispatch_get_main_queue(), ^(void) {
//            
//            
//            if([imageData length] > 1)
//            {
//                //UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
//                cell.imgUser.image = [UIImage imageWithData:imageData];
//            }
//            else
//            {
//            }
//            
//        });
//        
//        imageData = nil;
//    });
    //Locally Download The File:
//    cell.imgThumb.image=[UIImage imageWithContentsOfFile:localFilePath];
    return cell;
   
}


- (NSString *)MD5String:(NSString *)string{
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [data setLength:0];

    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1{
    [data appendData:data1];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"dictory value%@",dic);
    for (NSDictionary *diction in dic)
    {
     NSLog(@"%@",diction);

        [self.arrayName addObject:diction];
    }
    [self.tableView reloadData];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)erro
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Failed To Fetch Data From Server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Failed To Fetch Data From Server");
}

- (void)saveLocally:(NSData *)imgData name:(NSString *) receiveString
{
    
    NSString *strChange=[self MD5String:receiveString];
   localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",strChange]];
    NSLog(@"%@",localFilePath);
    [imgData writeToFile:localFilePath atomically:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
