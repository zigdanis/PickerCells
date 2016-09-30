//
//  ViewController.m
//  PickerCells
//
//  Created by Danis Ziganshin on 21/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "ViewController.h"
#import "TableDataSource.h"

@interface ViewController ()

@property (nonatomic, strong) TableDataSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[TableDataSource alloc] initWthTable:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Disable 1st" style:UIBarButtonItemStylePlain target:self.dataSource action:@selector(disableFirstPicker)];
}


@end
