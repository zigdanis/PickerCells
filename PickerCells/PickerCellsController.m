//
//  PickerCellsController.m
//  Example
//
//  Created by Danis Ziganshin on 21/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "PickerCellsController.h"
#import "PickerCellsDelegate.h"

#define kDefaultRowHeight 44
#define PickerCellIdentifier @"PickerCell"
#define kPickerTag 31

@interface PickerCellsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<UITableViewDataSource, UITableViewDelegate> priorDelegate;
@property (nonatomic, weak) id<PickerCellsDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *pickerIndexPath;
@property (nonatomic, strong) NSMutableDictionary *cellsWithPickersByIndexPaths;

@end

@implementation PickerCellsController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.cellsWithPickersByIndexPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Propetries

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Public

- (void)attachToTableView:(UITableView *)tableView tableViewsPriorDelegate:(id <UITableViewDelegate, UITableViewDataSource>)priorDelegate withDelegate:(id<PickerCellsDelegate>)delegate {
    self.priorDelegate = priorDelegate;
    self.tableView = tableView;
    self.delegate = delegate;
}

- (void)addPickerView:(UIPickerView *)pickerView forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PickerCellIdentifier];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    pickerView.tag = kPickerTag;
    [cell.contentView addSubview:pickerView];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(pickerView);
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[pickerView]-|" options:0 metrics:nil views:viewsDict]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pickerView]-|" options:0 metrics:nil views:viewsDict]];
    [self.cellsWithPickersByIndexPaths setObject:cell forKey:indexPath];
}

- (void)addDatePicker:(UIDatePicker *)datePicker forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PickerCellIdentifier];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.tag = kPickerTag;
    [cell.contentView addSubview:datePicker];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(datePicker);
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[datePicker]-|" options:0 metrics:nil views:viewsDict]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[datePicker]-|" options:0 metrics:nil views:viewsDict]];
    [self.cellsWithPickersByIndexPaths setObject:cell forKey:indexPath];
}

- (void)hidePicker {
    if (self.pickerIndexPath) {
        NSIndexPath *dateCellPath = [NSIndexPath indexPathForRow:_pickerIndexPath.row - 1 inSection:_pickerIndexPath.section];
        [self displayInlineDatePickerForRowAtIndexPath:dateCellPath];
    }
}

- (id)pickerForOwnerCellIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.cellsWithPickersByIndexPaths objectForKey:indexPath];
    id picker = [cell viewWithTag:kPickerTag];
    return picker;
}

- (NSIndexPath *)indexPathForPicker:(id)picker {
    for (NSIndexPath *key in self.cellsWithPickersByIndexPaths) {
        UITableViewCell *cell = [self.cellsWithPickersByIndexPaths objectForKey:key];
        id cellPicker = [cell viewWithTag:kPickerTag];
        if (cellPicker == picker) {
            return key;
        }
    }
    return nil;
}

#pragma mark - Private

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    BOOL sameCellClicked = ([self hasInlineDatePicker] && self.pickerIndexPath.row - 1 == indexPath.row)
    && self.pickerIndexPath.section == indexPath.section;
    
    if ([self hasInlineDatePicker]) {
        if (self.pickerIndexPath.row < indexPath.row &&
            self.pickerIndexPath.section == indexPath.section) {
            before = YES;
        }
        [self.tableView deleteRowsAtIndexPaths:@[self.pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    } else {
        if ([self.delegate respondsToSelector:@selector(pickerCellsController:willExpandTableViewContent:forHeight:)]) {
            CGFloat height = [self calculatedHeightForSizingCell:[self.cellsWithPickersByIndexPaths objectForKey:indexPath]];
            [self.delegate pickerCellsController:self willExpandTableViewContent:self.tableView forHeight:height];
        }
    }
    
    if (!sameCellClicked)  {
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:[indexPath section]];
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:[indexPath section]];
    } else {
        if ([self.delegate respondsToSelector:@selector(pickerCellsController:willCollapseTableViewContent:forHeight:)]) {
            CGFloat height = [self calculatedHeightForSizingCell:[self.cellsWithPickersByIndexPaths objectForKey:indexPath]];
            [self.delegate pickerCellsController:self willCollapseTableViewContent:self.tableView forHeight:height];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView endUpdates];
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:[indexPath section]]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (BOOL)hasInlineDatePicker {
    return (self.pickerIndexPath != nil);
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath {
    return ([self hasInlineDatePicker] && ([self.pickerIndexPath compare:indexPath] == NSOrderedSame));
}


#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathHasPicker:indexPath]) {
        return [self calculatedHeightForSizingCell:[self pickerCellForIndexPath:indexPath]];
    } else {
        if ([self.priorDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return [self.priorDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    return kDefaultRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [self.priorDelegate tableView:tableView numberOfRowsInSection:section];
    if ([self hasInlineDatePicker] && self.pickerIndexPath.section == section) {
        numberOfRows++;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([self indexPathHasPicker:indexPath]) {
        cell = [self pickerCellForIndexPath:indexPath];
    } else {
        NSIndexPath *shiftedIndexPath = [self shiftedIndexPathForIndexPath:indexPath];
        cell = [self.priorDelegate tableView:tableView cellForRowAtIndexPath:shiftedIndexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pickerIndexPath == indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSIndexPath *shiftedIndexPath = [self shiftedIndexPathForIndexPath:indexPath];
    
    if ([self.cellsWithPickersByIndexPaths objectForKey:shiftedIndexPath]) {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    
    if ([self.priorDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.priorDelegate tableView:tableView didSelectRowAtIndexPath:shiftedIndexPath];
    }
}

#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.priorDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.priorDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL respond = [super respondsToSelector:aSelector] || [self.priorDelegate respondsToSelector:aSelector];
    return respond;
}

#pragma mark - Helpers

- (NSIndexPath *)shiftedIndexPathForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *shiftedIndexPath = indexPath;
    if ([self hasInlineDatePicker] && self.pickerIndexPath.section == indexPath.section) {
        BOOL before = _pickerIndexPath.row < indexPath.row;
        int shift = before ? -1 : 0;
        shiftedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + shift inSection:indexPath.section];
    }
    return shiftedIndexPath;
}

- (UITableViewCell *)pickerCellForIndexPath:(NSIndexPath *)indexPath {
    NSAssert1(indexPath.row > 0, @"indexPath's row should be bigger than 0, indexPath row = %li", (long)indexPath.row);
    NSIndexPath *ownerCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    UITableViewCell *cell = [self.cellsWithPickersByIndexPaths objectForKey:ownerCellIndexPath];
    NSAssert2(cell != nil, @"Cell should not be nil for indexPath row = %li, section = %li", (long)indexPath.row, (long)indexPath.section);
    return cell;
}

- (CGFloat)calculatedHeightForSizingCell:(UITableViewCell *)sizingCell {
    NSAssert1(sizingCell != nil, @"Sizing method should not be called for if cell == nil", nil);
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

@end
