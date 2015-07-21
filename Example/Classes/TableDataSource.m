//
//  TableDataSource.m
//  PickerCells
//
//  Created by Danis Ziganshin on 21/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "TableDataSource.h"
#import "PickerCells.h"

@interface TableDataSource () <PickerCellsDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) PickerCellsController *pickersController;

@end

@implementation TableDataSource

- (instancetype)initWthTable:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self setupTableWithPickers];
    }
    return self;
}

- (void)setupTableWithPickers {
    self.pickersController = [[PickerCellsController alloc] init];
    [self.pickersController attachToTableView:self.tableView tableViewsPriorDelegate:self withDelegate:self];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    NSIndexPath *pickerIP = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.pickersController addPickerView:pickerView forIndexPath:pickerIP];
    
    UIDatePicker *datePicker1 = [[UIDatePicker alloc] init];
    datePicker1.datePickerMode = UIDatePickerModeDate;
    datePicker1.date = [NSDate date];
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.pickersController addDatePicker:datePicker1 forIndexPath:path1];
    
    UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
    datePicker2.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker2.date = [NSDate dateWithTimeIntervalSinceNow:5000];
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.pickersController addDatePicker:datePicker2 forIndexPath:path2];
    
    UIDatePicker *datePicker3 = [[UIDatePicker alloc] init];
    datePicker3.datePickerMode = UIDatePickerModeTime;
    datePicker3.date = [NSDate dateWithTimeIntervalSinceNow:5000];
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.pickersController addDatePicker:datePicker3 forIndexPath:path3];
    
    [datePicker1 addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [datePicker2 addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [datePicker3 addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];

}

#pragma mark - UITableView DataSOurce / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewInner cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellReuseId = @"id";
    
    UITableViewCell *cell = [tableViewInner dequeueReusableCellWithIdentifier:cellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
    }

    id picker = [self.pickersController pickerForOwnerCellIndexPath:indexPath];
    if (picker) {
        cell.textLabel.textColor = [UIColor blueColor];
        if ([picker isKindOfClass:UIPickerView.class]) {
            UIPickerView *pickerView = (UIPickerView *)picker;
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSString *title = [self pickerView:pickerView titleForRow:selectedRow forComponent:0];
            cell.textLabel.text = title;
        } else if ([picker isKindOfClass:UIDatePicker.class]) {
            UIDatePicker *datePicker = (UIDatePicker *)picker;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if (datePicker.datePickerMode == UIDatePickerModeDate) {
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            } else if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
                [dateFormatter setDateFormat:@"dd-MM-yyyy:HH-mm"];
            } else {
                [dateFormatter setDateFormat:@"HH-mm"];
            }
            cell.textLabel.text = [dateFormatter stringFromDate:[(UIDatePicker *)picker date]];
        }
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = [NSString stringWithFormat:@"Section: %ld row: %ld", (long)indexPath.section, (long)indexPath.row];
    }
    return cell;
     
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *text = [NSString stringWithFormat:@"Row number %li", (long)row];
    return text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSIndexPath *ip = [self.pickersController indexPathForPicker:pickerView];
    if (ip) {
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - PickerCellsDelegate

- (void)pickerCellsController:(PickerCellsController *)controller willExpandTableViewContent:(UITableView *)tableView forHeight:(CGFloat)expandHeight {
    NSLog(@"expand height = %.f", expandHeight);
}

- (void)pickerCellsController:(PickerCellsController *)controller willCollapseTableViewContent:(UITableView *)tableView forHeight:(CGFloat)expandHeight {
    NSLog(@"collapse height = %.f", expandHeight);
}

#pragma mark - Actions

- (void)dateSelected:(UIDatePicker *)sender {
    NSIndexPath *ip = [self.pickersController indexPathForPicker:sender];
    if (ip) {
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
