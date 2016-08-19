//
//  CreateChannelViewController.h
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateChannelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleNameTextField;

@property (weak, nonatomic) IBOutlet UITextView *descreptionTextView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
