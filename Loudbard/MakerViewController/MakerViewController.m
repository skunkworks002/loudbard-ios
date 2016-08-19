//
//  MakerViewController.m
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "MakerViewController.h"
#import "makerTableViewCell.h"
#import "ViewController.h"

@interface MakerViewController () {
    NSArray *channelSubArray;
    NSString *xcrfToken;
}

@end

@implementation MakerViewController
@synthesize mainTableView , showHideView,selecteChanneldArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    UIImage *searchimage = [UIImage imageNamed:@"searchIcon.png"];
    CGRect framesearchimg = CGRectMake(25,5, 25,25);
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:framesearchimg];
    [searchBtn setBackgroundImage:searchimage forState:UIControlStateNormal];
  //  [searchBtn addTarget:self action:@selector(showBottomViewFunction)forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *sarchbutton =[[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIImage *menuImage = [UIImage imageNamed:@"menuIcon.png"];
    CGRect frameImg = CGRectMake(15,5, 25,25);
    UIButton *setingBtn = [[UIButton alloc] initWithFrame:frameImg];
    [setingBtn setBackgroundImage:menuImage forState:UIControlStateNormal];
    [setingBtn addTarget:self action:@selector(showBottomViewFunction)forControlEvents:UIControlEventTouchUpInside];
    [setingBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *sbutton =[[UIBarButtonItem alloc] initWithCustomView:setingBtn];
    
    self.navigationItem.rightBarButtonItems  = [NSArray arrayWithObjects:sbutton,sarchbutton, nil];
    // Do any additional setup after loading the view.

    [self slecetedchannelList];
}

-(void)slecetedchannelList {
    NSString *vidOfChennel = [selecteChanneldArray valueForKey:@"vid"];
    NSLog(@"%@",vidOfChennel);
    NSString *url = [NSString stringWithFormat:@"http://loudbard-dev.xululabs.us/restchannel/pullarticle/retrieve?channel_id=%@",vidOfChennel];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSMutableArray *jsoDictrionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            channelSubArray = jsoDictrionary;
                                                            [mainTableView reloadData];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnUpAction:(id)sender {
    NSLog(@"up button call");
}

-(IBAction)btnDownAction:(id)sender {
    NSLog(@"down button call");
}

-(IBAction)homeBtnAction:(id)sender {
    NSLog(@"home button call");
}

-(IBAction)createChannelBtnAction:(id)sender {

}

-(IBAction)logOutbtnAction:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString*xcrfValue;
        if ([savedData objectForKey:@"xcrfTokenValue"] != nil) {
            
            xcrfValue = [savedData valueForKey:@"xcrfTokenValue"];
        }
    NSDictionary *headers = @{ @"content-type": @"application/json" , @"X-CSRF-Token" :xcrfValue};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loudbard-dev.xululabs.us/restchannel/user/logout"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSMutableArray *jsoDictrionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            xcrfToken = @"logout";
                                                            [self xcrfTokenDataSave];
                                                            [self performSegueWithIdentifier: @"ViewController" sender:nil];
                                                        });
                                                    }
                                                }];
            
            [dataTask resume];
    }
    else {
    
        NSLog(@"logOut Fail");
    }

}

-(IBAction)cancelBtnAction:(id)sender {
    showHideView.hidden = YES;
}
-(void)showBottomViewFunction {

    showHideView.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (channelSubArray.count == 0) {
        return 0;
    } else {
    return [channelSubArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"makerTableViewCell";
    makerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[makerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *titleOfChannel = [channelSubArray valueForKey:@"Title"];
        NSArray *bodyOfChannel = [channelSubArray valueForKey:@"Body"];
        cell.titleLabel.text = [titleOfChannel objectAtIndex:indexPath.section];
        cell.detailTextView.text = [bodyOfChannel objectAtIndex:indexPath.section];
    });
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray*)sender {
    if ([[segue identifier] isEqualToString:@"ViewController"]) {
        ViewController    *destinationView = (ViewController*)segue.destinationViewController;
    }
}

- (void)xcrfTokenDataSave {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (xcrfToken != nil) {
        [dataDict setObject:xcrfToken forKey:@"logout"];  // save
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}



@end
