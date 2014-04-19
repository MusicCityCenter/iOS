//
//  MCCFilterEventViewController.m
//  Music City Center
//
//  Created by Marissa Montgomery on 4/2/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFilterViewController.h"
#import "MCCSecondFilterTableTableViewController.h"

static NSString *kPersonCellID = @"personCell";
static NSString *kPersonCellID2 = @"personCell2";
static NSString *kPersonCellID3 = @"personCell3";
static NSString *kDatePickerCellID = @"datePickerCell";
static NSString *kDatePickerCellID2 = @"datePickerCell2";
static NSString *kDatePickerCellID3 = @"datePickerCell3";

@interface MCCFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) CGFloat pickerCellRowHeight;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath3;
@property (strong, nonatomic) MCCSecondFilterTableTableViewController *secondTableVC;
@property (nonatomic) BOOL from;
@property (nonatomic) IBOutlet UIDatePicker* datePicker;
@property (strong, nonatomic) NSDate *toDate;
@property (strong, nonatomic) NSDate *fromDate;

@end

@implementation MCCFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self createDateFormatter];
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    self.fromDate = [NSDate date];
    self.toDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ((self.toDate != nil) && (self.fromDate != nil)){
        
    }
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (BOOL)datePickerIsShown {
    
    return self.datePickerIndexPath != nil;
}


- (BOOL)datePickerIsShown3 {
    
    return self.datePickerIndexPath3 != nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        if ([self datePickerIsShown] && [self datePickerIsShown3]){
            return 4;
        } else if ([self datePickerIsShown]){
            return 3;
        } else if ([self datePickerIsShown3]){
            return 3;
        }
        return 2;

}



- (IBAction)fromValueChanged:(UIDatePicker *)sender {
    
    NSLog(@"Whatevaaa%@", [self.dateFormatter stringFromDate:[sender date]]);
    self.fromDate = [sender date];
    NSIndexPath *parentCellIndexPath = nil;
    
    if ([self datePickerIsShown]){
        
        parentCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
        
    }else {
        
        return;
    }
    
    UITableViewCell *cellA = [self.tableView cellForRowAtIndexPath:parentCellIndexPath];
    
    cellA.detailTextLabel.text = [self.dateFormatter stringFromDate:sender.date];
}

- (IBAction)toValueChanged:(UIDatePicker *)sender {
    
    NSLog(@"Whatevaaa%@", [self.dateFormatter stringFromDate:[sender date]]);
    self.toDate = [sender date];
    NSIndexPath *parentCellIndexPath = nil;
    
    if ([self datePickerIsShown3]){
        
        parentCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath3.row - 1 inSection:0];
        
    }else {
        
        return;
    }
    
    UITableViewCell *cellA = [self.tableView cellForRowAtIndexPath:parentCellIndexPath];
    cellA.detailTextLabel.text = [self.dateFormatter stringFromDate:sender.date];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
        if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row && tableView ==  _tableView)){
            NSTimeInterval hour = 0;
            NSDate *displayTime = [[NSDate alloc]
                                initWithTimeIntervalSinceNow:hour];
            UIDatePicker *targetedDatePicker;
            UITableViewCell *cellTemp = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
            targetedDatePicker = (UIDatePicker *)[cellTemp viewWithTag:1];
            if (self.fromDate != nil){
                displayTime = self.fromDate;
            }
            [targetedDatePicker setDate:displayTime animated:NO];
            [targetedDatePicker addTarget:self action:@selector(fromValueChanged:) forControlEvents: UIControlEventValueChanged];
            return cellTemp;
        } else if ([self datePickerIsShown3] && self.datePickerIndexPath3.row == indexPath.row && tableView == _tableView){
            NSTimeInterval hour = 0;
            NSDate *displayTime = [[NSDate alloc]
                                initWithTimeIntervalSinceNow:hour];
            UIDatePicker *targetedDatePicker;
            UITableViewCell *cellTemp = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID3];
            targetedDatePicker = (UIDatePicker *)[cellTemp viewWithTag:4];
            if (self.toDate != nil){
                displayTime = self.toDate;
            }
            [targetedDatePicker setDate:displayTime animated:NO];
            [targetedDatePicker addTarget:self action:@selector(toValueChanged:) forControlEvents: UIControlEventValueChanged];
            return cellTemp;
        } else {
        if (indexPath.row == 0){
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID];
            cell.textLabel.text = @"From";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            UITableViewCell *cellPicker = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
            UIDatePicker *targetedDatePicker = (UIDatePicker *)[cellPicker viewWithTag:1];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[targetedDatePicker date]];
            return cell;
        } else {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID3];
            cell.textLabel.text = @"To";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            UITableViewCell *cellPicker = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID3];
            UIDatePicker *targetedDatePicker = (UIDatePicker *)[cellPicker viewWithTag:4];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[targetedDatePicker date]];
            return cell;
        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)){
        [self hideExistingPicker];
    } else if ([self datePickerIsShown3] && (self.datePickerIndexPath3.row - 1 == indexPath.row)){
        NSLog(@"here");
        [self hideExistingPicker3];
    } else if ([self datePickerIsShown] && indexPath.row == 2){
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker3:indexPath];
        if ([self datePickerIsShown3]){
            [self hideExistingPicker3];
        }
        [self showNewPickerAtIndex3:newPickerIndexPath];
        self.datePickerIndexPath3 = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
    } else if (![self datePickerIsShown] && indexPath.row == 1){
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker3:indexPath];
        if ([self datePickerIsShown3]){
            [self hideExistingPicker3];
        }
        [self showNewPickerAtIndex3:newPickerIndexPath];
        self.datePickerIndexPath3 = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
    } else {
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        if ([self datePickerIsShown3]){
            [self hideExistingPicker3];
        }
        [self showNewPickerAtIndex:newPickerIndexPath];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView endUpdates];
    
    

}

- (void)hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    self.datePickerIndexPath = nil;
}


- (void)hideExistingPicker3 {

    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath3.row inSection:0]]
                           withRowAnimation:UITableViewRowAnimationFade];
    self.datePickerIndexPath3 = nil;
}

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:0];
        
    }
    
    return newIndexPath;
}


- (NSIndexPath *)calculateIndexPathForNewPicker3:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown3]) && (self.datePickerIndexPath3.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:0];
        
    }
    
    return newIndexPath;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}


- (void)showNewPickerAtIndex3:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                           withRowAnimation:UITableViewRowAnimationFade];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
        if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
            rowHeight = self.pickerCellRowHeight;
        
        } else if ([self datePickerIsShown3] && (self.datePickerIndexPath3.row == indexPath.row)){
            
            rowHeight = self.pickerCellRowHeight;
            
        }

    
    return rowHeight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
