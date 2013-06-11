//
//  FilterViewController.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FilterViewController : NSViewController

@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) IBOutlet NSArrayController *filtersController;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, strong) NSDictionary *filterOptions;
@property (nonatomic, strong) IBOutlet NSDictionaryController *filterOptionsController;

@end
