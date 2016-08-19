//
//  ChannelListViewController.h
//  Loudbard
//
//  Created by Xululabs on 17/08/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *MainTableView;

@property (weak, nonatomic) IBOutlet UIButton *multipleOptionBtn;
@property (weak, nonatomic) IBOutlet UIButton *menueOptionBtn;
@property (weak, nonatomic) IBOutlet UIButton *createChannelBtn;

@end
