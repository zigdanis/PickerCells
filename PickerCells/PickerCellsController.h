//
//  PickerCellsController.h
//  Example
//
//  Created by Danis Ziganshin on 21/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerCellsDelegate;

@interface PickerCellsController : NSObject

- (void)attachToTableView:(UITableView *)tableView tableViewsPriorDelegate:(id <UITableViewDelegate, UITableViewDataSource>)priorDelegate withDelegate:(id<PickerCellsDelegate>)delegate;
- (void)addDatePicker:(UIDatePicker *)datePicker forIndexPath:(NSIndexPath *)indexPath;
- (void)addPickerView:(UIPickerView *)pickerView forIndexPath:(NSIndexPath *)indexPath;
- (void)hidePicker;
- (id)pickerForOwnerCellIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForPicker:(id)picker;

@end
