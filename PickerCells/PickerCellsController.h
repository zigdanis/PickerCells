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

/* This method attaching PickerCellController to your `tableView`.
   PickerCellsController then will propogate UITableViewDataSource and UITableViewDelegate calls to your `priorDelegate` object.
   Also you can provide your PickerCellsDelegate object in order to receive willExpand and willCollapse callbacks.
 */
- (void)attachToTableView:(UITableView *)tableView tableViewsPriorDelegate:(id <UITableViewDelegate, UITableViewDataSource>)priorDelegate withDelegate:(id<PickerCellsDelegate>)delegate;

/* Use this method to setup PickerCellsController with `datePicker` that will be shown when user tapping on specified `indexPath`
 */
- (void)addDatePicker:(UIDatePicker *)datePicker forIndexPath:(NSIndexPath *)indexPath;

/* Use this method to setup PickerCellsController with `pickerView` that will be shown when user tapping on specified `indexPath`
 */
- (void)addPickerView:(UIPickerView *)pickerView forIndexPath:(NSIndexPath *)indexPath;

/* You can remove previously added picker from the specified indexPath to prevent it's expanding by user's tap.
 */
- (void)removePickerAtIndexPath:(NSIndexPath *)indexPath;

/* Use this method to hide currently shown picker programmatically. Notice that only 1 picker can be shown at a time.
 */
- (void)hidePicker;

/* This method can be used to retrieve `picker` that were previously attached to the `indexPath` with -addDatePicker:forIndexPath: or -addPickerView:forIndexPath
 */
- (id)pickerForOwnerCellIndexPath:(NSIndexPath *)indexPath;

/* This methid can be used to retrieve 'indexPath' that were previously attached to the `picker` with -addDatePicker:forIndexPath: or -addPickerView:forIndexPath
 */
- (NSIndexPath *)indexPathForPicker:(id)picker;

@end
