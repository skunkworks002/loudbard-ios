//
//  ViewController.m
//  Loudbard
//
//  Created by Xululabs on 27/07/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "ChannelListViewController.h"

@interface ViewController () {
    NSString *xcrfToken;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//
    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Button Action Methodes -

-(IBAction)alreadyHaveAccountBtnAction:(id)sender {
    [self loadDataSaved];
}

-(IBAction)signUpBtnAction:(id)sender{
    NSLog(@"sign up button call");
}

#pragma Custon Methodes -

-(void)loadDataSaved {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([savedData objectForKey:@"xcrfTokenValue"] != nil) {
        //NSString*myValue = [savedData valueForKey:@"xcrfTokenValue"];
        [self performSegueWithIdentifier:@"ChannelListViewController" sender:nil];
    }
    else {
        [self performSegueWithIdentifier:@"LoginViewController" sender:nil];
    }
    }
    else {
        [self performSegueWithIdentifier:@"LoginViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableArray*)sender {
    if ([[segue identifier] isEqualToString:@"LoginViewController"]) {
        LoginViewController    *destinationView = (LoginViewController*)segue.destinationViewController;
    }
    else {
    ChannelListViewController *destinationView = (ChannelListViewController*)segue.destinationViewController;
    
    }
}

@end