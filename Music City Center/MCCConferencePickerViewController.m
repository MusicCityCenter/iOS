//
//  MCCConferencePickerViewController.m
//  Music City Center
//
//  Created by Marissa Montgomery on 4/9/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCConferencePickerViewController.h"

static NSString *kCellIdentifier = @"ConferenceCell";

@interface MCCConferencePickerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *conferences;
@property (strong, nonatomic) NSString *selectedConference;
@property (nonatomic) BOOL cleared;


@end

@implementation MCCConferencePickerViewController

- (IBAction)clearButtonPressed:(id)sender {
    self.selectedConference = nil;
    self.cleared = YES;
    [self.tableView reloadData];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    self.cleared = NO;
    //self.conferences = [[NSArray alloc] init];
    //self.conferences = [NSArray arrayWithObjects:@"Conference A", @"Conference B", @"Conference C", @"Conference D", nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conferences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
    //  forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    
    NSString *thisText = self.conferences[indexPath.row];
    
    cell.textLabel.text = thisText;
    
    if (self.cleared){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == self.conferences.count - 1){
            self.cleared = NO;
            [tableView reloadData];
        }
    }

    return cell;
}

- (void)conferencesToDisplay:(NSMutableArray *)conferenceList {
    self.conferences = conferenceList;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedConference = self.conferences[indexPath.row];
    NSLog(@"%@", self.selectedConference);
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
