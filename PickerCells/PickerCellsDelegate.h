//
//  PickerCellsDelegate.h
//  Example
//
//  Created by Danis Ziganshin on 21/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerCellsController;
@protocol PickerCellsDelegate <UITableViewDataSource, UITableViewDelegate>

@optional
- (void)pickerCellsController:(PickerCellsController *)controller willExpandTableViewContent:(UITableView *)tableView forHeight:(CGFloat)expandHeight;
- (void)pickerCellsController:(PickerCellsController *)controller willCollapseTableViewContent:(UITableView *)tableView forHeight:(CGFloat)expandHeight;

@end