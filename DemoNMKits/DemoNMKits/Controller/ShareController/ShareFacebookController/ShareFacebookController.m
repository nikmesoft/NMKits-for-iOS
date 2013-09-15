//
//  ShareFacebookController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "ShareFacebookController.h"
#import <NMKits/NMShareKit.h>
#import <NMKits/NMUIHelper.h>


#define SHARE_TITLE             @"NMShareKit"
#define SHARE_MESSAGE           @"Debug NMKits for iOS v2.0"
#define SHARE_LINK              @"http://www.nikmesoft.com"
#define SHARE_IMAGE             [UIImage imageNamed:@"appicon_120.png"]


@interface ShareFacebookController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ShareFacebookController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Facebook";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setXib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private's method

- (void)setXib
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"Share Photo",@"Share Status", @"Share URL", nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonDidPressed:)];
}

#pragma mark - Action

- (IBAction)backButtonDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // Share photo and text
            [[NMShareKit sharedManager] fbPostPhoto:SHARE_IMAGE message:SHARE_MESSAGE completionHandler:^(BOOL sucessfully,NSError *error, NSDictionary *dataDict){
                if (sucessfully) {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:@"Shared" delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                } else {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:error.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                }
            }];
        }
            break;
        case 1:
        {
            // Share text
            [[NMShareKit sharedManager] fbPostStatus:SHARE_MESSAGE completionHandler:^(BOOL sucessfully,NSError *error, NSDictionary *dataDict){
                if (sucessfully) {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:@"Shared" delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                } else {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:error.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                }
            }];
        }
            break;
        case 2:
        {
            // Share URL
            [[NMShareKit sharedManager] fbShareURL:SHARE_MESSAGE url:SHARE_LINK completionHandler:^(BOOL sucessfully,NSError *error, NSDictionary *dataDict){
                if (sucessfully) {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:@"Shared" delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                } else {
                    [NMUIHelper showAlertWithTitle:SHARE_TITLE message:error.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
