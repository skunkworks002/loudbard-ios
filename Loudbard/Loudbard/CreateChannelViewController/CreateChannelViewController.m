//
//  CreateChannelViewController.m
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "CreateChannelViewController.h"

@interface CreateChannelViewController (){
    NSString *xcrfToken;
}

@end

@implementation CreateChannelViewController
@synthesize titleNameTextField,descreptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    // Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([savedData objectForKey:@"xcrfTokenValue"] != nil) {
            xcrfToken = [savedData valueForKey:@"xcrfTokenValue"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancleBtnAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

-(IBAction)saveCreateNodeButton:(id)sender
{
    NSString *titleChennel = titleNameTextField.text;
    NSString *type = @"channel";
    NSString *messageBody = descreptionTextView.text;
    
    if ([titleChennel isEqualToString:@""] || [messageBody isEqualToString:@""]) {
        NSLog(@"please enter title and description");
    } else {
    
    // channel Creation - - -
    NSDictionary *headers = @{ @"content-type": @"application/json", @"x-csrf-token": xcrfToken };

//    NSDictionary *parameters = @{ @"title": @"app testing for channel creation iphone5",
//                                  @"type": @"channel",
//                                  @"field_feature": @{ @"und": @[ @{ @"value": @"this is first channel to create from iphon5" } ] } };
//    
    NSDictionary *parameters = @{ @"title": titleChennel,
                                  @"type": type,
                                  @"field_feature": @{ @"und": @[ @{ @"value": messageBody } ] } };

        // artical Creation - -
    
//    NSDictionary *parameters = @{ @"title": @"test from iphone5",
//                                  @"type": @"article",
//                                  @"body": @{ @"und": @[ @{ @"value": @"body of test article" } ] } };
    
    // NSDictionary *parameters = @{ @"title": titleChennel,
     //                             @"type": type,
       //                           @"body": @{ @"und": @[ @{ @"value": messageBody } ] } };
    // - -
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://loudbard-dev.xululabs.us/restchannel/node"]
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
                                                        
                                                        NSLog(@"%@", jsoDictrionary);

                                                    }
                                                }];
    [self dismissModalViewControllerAnimated:YES];
    [dataTask resume];
    }
}

@end
