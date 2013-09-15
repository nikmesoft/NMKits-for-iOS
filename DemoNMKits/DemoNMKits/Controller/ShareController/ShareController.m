//
//  ShareController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "ShareController.h"

#import <NMKits/NMShareKit.h>
#import <NMKits/NMUIHelper.h>

#import "ShareFacebookController.h"
#import "ShareGoogleplusController.h"



#define SHARE_TITLE             @"NMShareKit"
#define SHARE_MESSAGE           @"Debug NMKits for iOS v2.0"
#define SHARE_LINK              @"http://www.nikmesoft.com"
#define SHARE_IMAGE             [UIImage imageNamed:@"appicon_120.png"]


@interface ShareController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ShareController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Social Sharing";
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

#pragma mark - private's method

- (void)setXib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter",@"GooglePlus",@"E-mail", nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonDidPressed:)];
}

- (NSString *)getAppinfo
{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    //NSString *appID = [appInfo objectForKey:@"CFBundleIdentifier"];
    NSString *appVersion = [appInfo objectForKey:@"CFBundleVersion"];
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    NSString *device = [[UIDevice currentDevice] model];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"\n\n\nLocale: %@.\nDevice Model: %@.\nOS version: %@.\nApp Name : %@.\nApp version: %@.", locale, device, osVersion,appName, appVersion];
    return message;
}

- (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withTag:(NSInteger)tag withTitleButtonCancel:(NSString *)titleButtonCancel andTitleButtonOther:(NSString *)otherButtonTitles
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:titleButtonCancel otherButtonTitles:otherButtonTitles, nil];
    alertView.tag = tag;
    [alertView show];
    alertView = nil;
    
}

#pragma mark - Action

- (IBAction)backButtonDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

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
            // Facebook share
            ShareFacebookController *shareFBController = [[ShareFacebookController alloc] initWithNibName:@"ShareFacebookController" bundle:nil];
            [self.navigationController pushViewController:shareFBController animated:YES];
        }
            break;
        case 1:
        {
            // Twitter share
            [[NMShareKit sharedManager] twShareWithText:SHARE_MESSAGE image:SHARE_IMAGE url:SHARE_LINK completionHandler:^(BOOL sucessfully,NSError *error, NSDictionary *dataDict){
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
            // Googleplus share
            ShareGoogleplusController *shareGPController = [[ShareGoogleplusController alloc] initWithNibName:@"ShareGoogleplusController" bundle:nil];
            [self.navigationController pushViewController:shareGPController animated:YES];
        }
            break;
        case 3:
        {
            // E-mail share
            NSArray *array = [NSArray arrayWithObjects:@"nikmesoft@gmail.com", nil];
            [[NMShareKit sharedManager] shareEmailWithSubject:SHARE_MESSAGE body:[self getAppinfo] image:nil isHTML:NO toRecipients:array completionHandler:^(BOOL sucessfully,NSError *error,NSDictionary* dataDict)
             {
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
