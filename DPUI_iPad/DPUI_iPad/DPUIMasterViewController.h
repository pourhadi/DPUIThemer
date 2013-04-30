//
//  DPUIMasterViewController.h
//  DPUI_iPad
//
//  Created by Daniel Pourhadi on 4/30/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPUIDetailViewController;

@interface DPUIMasterViewController : UITableViewController

@property (strong, nonatomic) DPUIDetailViewController *detailViewController;

@end
