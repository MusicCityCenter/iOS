//
//  MCCFilterEventViewController.m
//  Music City Center
//
//  Created by Marissa Montgomery on 4/2/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFilterViewController.h"

static NSString *kPersonCellID = @"personCell";
static NSString *kDatePickerCellID = @"datePickerCell";

@interface MCCFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *persons;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CGFloat pickerCellRowHeight;
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
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (BOOL)datePickerIsShown {
    
    return self.datePickerIndexPath != nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self datePickerIsShown]){
        
        return 2;
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        NSTimeInterval hour = 60 * 60;
        NSDate *tomorrow = [[NSDate alloc]
                            initWithTimeIntervalSinceNow:hour];
        cell = [self createPickerCell:tomorrow];
        
    }else {

        cell = [self createPersonCell];
    }
    
    return cell;
}

- (UITableViewCell *)createPersonCell {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID];
    
    cell.textLabel.text = @"From";
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    
    return cell;
    
}

- (UITableViewCell *)createPickerCell:(NSDate *)date {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    
    UIDatePicker *targetedDatePicker = (UIDatePicker *)[cell viewWithTag:1];
    
    [targetedDatePicker setDate:date animated:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)){
        
        [self hideExistingPicker];
        
    }else {
        
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        
        if ([self datePickerIsShown]){
            
            [self hideExistingPicker];
            
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

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)){
        
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
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
