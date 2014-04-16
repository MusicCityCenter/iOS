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
static NSString *kDatePickerCellID = @"datePickerCell";
static NSString *kDatePickerCellID2 = @"datePickerCell2";

@interface MCCFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) CGFloat pickerCellRowHeight;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath2;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) MCCSecondFilterTableTableViewController *secondTableVC;
@property (nonatomic) BOOL from;

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
    //self.tableView2.delegate = self.secondTableVC;
    //self.tableView2.dataSource = self.secondTableVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (BOOL)datePickerIsShown {
    
    return self.datePickerIndexPath != nil;
}

- (BOOL)datePickerIsShown2 {
    
    return self.datePickerIndexPath2 != nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == _tableView){
        if ([self datePickerIsShown]){
            
            return 2;
            
        }
        
        return 1;
    } else {
    if ([self datePickerIsShown2]){
        
        return 2;
        
    }
    
    return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row) && tableView == _tableView){
        NSTimeInterval hour = 0;
        NSDate *tomorrow = [[NSDate alloc]
                            initWithTimeIntervalSinceNow:hour];
        UIDatePicker *targetedDatePicker;
        UITableViewCell *cellTemp = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
        targetedDatePicker = (UIDatePicker *)[cell viewWithTag:1];
        [targetedDatePicker setDate:tomorrow animated:NO];
        return cellTemp;
        
    }else if ([self datePickerIsShown2] && (self.datePickerIndexPath2.row == indexPath.row) && tableView == _tableView2){
        NSTimeInterval baseTime = 0;
        NSDate *now = [[NSDate alloc]
                            initWithTimeIntervalSinceNow:baseTime];
        UIDatePicker *targetedDatePicker;
        UITableViewCell *cellTemp = [self.tableView2 dequeueReusableCellWithIdentifier:kDatePickerCellID2];
        targetedDatePicker = (UIDatePicker *)[cell viewWithTag:2];
        [targetedDatePicker setDate:now animated:NO];
        return cellTemp;
        
    } else {

        if (tableView == _tableView){
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID];
            cell.textLabel.text = @"From";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            return cell;
        } else {
            UITableViewCell *cell = [self.tableView2 dequeueReusableCellWithIdentifier:kPersonCellID2];
            cell.textLabel.text = @"To";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            return cell;
        }
    }
    
    return cell;
}

/*
- (UITableViewCell *)createPickerCell:(NSDate *)date tableView:(UITableView *)tableView{
    
    UIDatePicker *targetedDatePicker;
    if (tableView == _tableView){
        UIDatePicker *targetedDatePicker;
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
        targetedDatePicker = (UIDatePicker *)[cell viewWithTag:1];
        [targetedDatePicker setDate:date animated:NO];
        return cell;
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID2];
        targetedDatePicker = (UIDatePicker *)[cell viewWithTag:2];
        [targetedDatePicker setDate:date animated:NO];
        return cell;
    }

}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView){
    
    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)){
        
        [self hideExistingPicker];
        
    }else {
        
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker2:indexPath];
        
        if ([self datePickerIsShown]){
            
            [self hideExistingPicker];
            
        }

        [self showNewPickerAtIndex:newPickerIndexPath];
        
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.tableView endUpdates];
    } else {
        
        [self.tableView2 beginUpdates];
        
        if ([self datePickerIsShown2] && (self.datePickerIndexPath2.row - 1 == indexPath.row)){
            
            [self hideExistingPicker2];
            
        }else {
            
            NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker2:indexPath];
            
            if ([self datePickerIsShown2]){
                
                [self hideExistingPicker2];
                
            }
            
            [self showNewPickerAtIndex2:newPickerIndexPath];
            
            self.datePickerIndexPath2 = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
            
        }
        
        [self.tableView2 deselectRowAtIndexPath:indexPath animated:NO];
        
        [self.tableView2 endUpdates];
    }
}

- (void)hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
}

- (void)hideExistingPicker2 {
    
    [self.tableView2 deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath2.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath2 = nil;
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

- (NSIndexPath *)calculateIndexPathForNewPicker2:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown2]) && (self.datePickerIndexPath2.row < selectedIndexPath.row)){
        
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

- (void)showNewPickerAtIndex2:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView2 insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    if (tableView == _tableView){
        if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
            rowHeight = self.pickerCellRowHeight;
        
        }
    } else {
        if ([self datePickerIsShown2] && (self.datePickerIndexPath2.row == indexPath.row)){
        
            rowHeight = self.pickerCellRowHeight;
        
        }
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
