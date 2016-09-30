# PickerCells
This class adds UIDatePicker or UIPickerView that will expand or collapse by tapping on the cell in your UITableView.

Inspired by Apple's [DateCell](https://developer.apple.com/library/ios/samplecode/DateCell/Introduction/Intro.html) example and [andjash's](https://github.com/andjash) [DateCellsController](https://github.com/andjash/DateCellsController).

## Screenshots
<img src=http://i.imgur.com/Z8vbhNFl.png>
<img src=http://i.imgur.com/WfgTUtel.png>
## Minimum iOS version
iOS 6.0
## Usage
1. Import with `#import "PickerCells.h"`
2. Instantiate and setup `PickerCellsController` class.

  ```objective-c
  self.pickersController = [[PickerCellsController alloc] init];
  [self.pickersController attachToTableView:self.tableView tableViewsPriorDelegate:self withDelegate:self];
  ```
3. Add `UIPickerView` and `UIDatePicker` instances with correspoding indexPaths

  ```objective-c
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
  ``` 
4. Check it out! Try pressing cells on specified indexPath's to see how pickers will expand underneath them.
5. This class do not responsible for giving you information about picker selected values. You should do it by yourself. But you can get pickers from `PickerCellsController` object by using corresponding cells indexPaths:

  ```objective-c
  id picker = [self.pickersController pickerForOwnerCellIndexPath:indexPath];
  if ([picker isKindOfClass:UIDatePicker.class]) {
    UIDatePicker *datePicker = (UIDatePicker *)picker;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    cell.textLabel.text = [dateFormatter stringFromDate:[datePicker date]];
  }
  ```
  
## Installation

```sh
pod 'PickerCells'
```

## License
MIT
