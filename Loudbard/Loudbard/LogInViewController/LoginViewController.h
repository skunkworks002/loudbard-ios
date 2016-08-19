//
//  LoginViewController.h
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTetxField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *forgetUserNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@end
