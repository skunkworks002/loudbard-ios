//
//  LoginViewController.m
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "LoginViewController.h"
#import "ChannelListViewController.h"

@interface LoginViewController () {
    NSString *xcrfToken;
}

@end

@implementation LoginViewController
@synthesize userNameTetxField,passwordTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Button Action Methods -

-(IBAction)loginButtonAction:(id)sender {
    if ([userNameTetxField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""]) {
        NSLog(@"enter user name and password also");
    }
    else {
        [self loginStatuscheckFunc];
    }
}

-(IBAction)forgetUserNameBtnAtion:(id)sender {
    NSLog(@"forget button call");
}

-(IBAction)forgetPasswordBtnAction:(id)sender {
    NSLog(@"forget password button call");
}

#pragma Methods used for this class

-(void)loginStatuscheckFunc {
    NSString*userName =userNameTetxField.text;
    NSString *password = passwordTextField.text;
    
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    NSDictionary *parameters = @{ @"username": userName,
                                  @"password": password };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loudbard-dev.xululabs.us/restchannel/user/login"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSDictionary *jsoDictrionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        if (jsoDictrionary.count <= 1) {
                                                            NSLog(@"xcrf token validation fail");
                                                        }
                                                        else {
                                                        xcrfToken = [jsoDictrionary valueForKey:@"token"];
                                                            [self xcrfTokenDataSave];
                                                        if ([xcrfToken isEqualToString:@""]) {
                                                            NSLog(@"sorry time out");
                                                        }
                                                        else {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self performSegueWithIdentifier:@"ChannelListViewController" sender:nil];
                                                            });
                                                        }
                                                    }
                                                    }
                                                }];
    [dataTask resume];
}


- (void)xcrfTokenDataSave {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (xcrfToken != nil) {
        [dataDict setObject:xcrfToken forKey:@"xcrfTokenValue"];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableArray*)sender {
    if ([[segue identifier] isEqualToString:@"ChannelListViewController"]) {
        ChannelListViewController    *destinationView = (ChannelListViewController*)segue.destinationViewController;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}


@end
