//
//  ChannelListViewController.m
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "ChannelListViewController.h"
#import "ChannelListTableViewCell.h"
#import "MakerViewController.h"

@interface ChannelListViewController () {
    NSArray *channelListArray;
}

@end

@implementation ChannelListViewController
@synthesize MainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    UIImage *searchimage = [UIImage imageNamed:@"searchIcon.png"];
    CGRect framesearchimg = CGRectMake(25,5, 25,25);
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:framesearchimg];
    [searchBtn setBackgroundImage:searchimage forState:UIControlStateNormal];
    //[searchBtn addTarget:self action:@selector(searchBarFunction)forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *sarchbutton =[[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = sarchbutton;
    
    UIImage *menuImage = [UIImage imageNamed:@"menuIcon.png"];
    CGRect frameImg = CGRectMake(15,5, 25,25);
    UIButton *setingBtn = [[UIButton alloc] initWithFrame:frameImg];
    [setingBtn setBackgroundImage:menuImage forState:UIControlStateNormal];
    [setingBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *sbutton =[[UIBarButtonItem alloc] initWithCustomView:setingBtn];
    self.navigationItem.leftBarButtonItem = sbutton;    //s = [NSArray arrayWithObjects:sbutton,sarchbutton, nil];
    
    [self channelListCallingMethode];
}


-(void)channelListCallingMethode {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loudbard-dev.xululabs.us/restchannel/node"]
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
                                                            NSMutableArray* entries= [NSMutableArray array];
                                                            for(NSDictionary* dict in jsoDictrionary)
                                                            {
                                                                if([dict[@"type"] isEqualToString: @"channel"])
                                                                {
                                                                    [entries addObject: dict];
                                                                }
                                                            }
                                                            channelListArray = entries;
                                                            [MainTableView reloadData];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (channelListArray.count == 0) {
        return 0;
    }else {
    return [channelListArray count];;//1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; //[nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChannelListTableViewCell";
    ChannelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChannelListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *channelTitles = [channelListArray valueForKey:@"title"];
        cell.channelNameLabel.text = [channelTitles objectAtIndex:indexPath.section];
        });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *selectedArray = [channelListArray objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier: @"MakerViewController" sender:selectedArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice,
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray*)sender {
    if ([[segue identifier] isEqualToString:@"MakerViewController"]) {
        MakerViewController    *destinationView = (MakerViewController*)segue.destinationViewController;
        destinationView.selecteChanneldArray = sender;
        
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
    [[self MainTableView] endEditing:YES];
}

@end
