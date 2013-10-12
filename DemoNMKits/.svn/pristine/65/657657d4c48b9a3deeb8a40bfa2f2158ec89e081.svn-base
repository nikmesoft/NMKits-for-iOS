//
//  MainController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "MainController.h"

#import "ShareController.h"
#import "AuthenticationController.h"
#import "InAppPurchaseController.h"
#import "WebserviceController.h"

@interface MainController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Demo NMKits framework";
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"Social Sharing",@"Social Authentication",@"In-App Purchase",@"RESTful + JSON Web Services", nil];
}

#pragma mark - Action


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
            // Socil share
        {
            ShareController *shareController = [[ShareController alloc] initWithNibName:@"ShareController" bundle:nil];
            [self.navigationController pushViewController:shareController animated:YES];
        }
            break;
        case 1:
        {
            // Authentication
            AuthenticationController *authenticationController = [[AuthenticationController alloc] initWithNibName:@"AuthenticationController" bundle:nil];
            [self.navigationController pushViewController:authenticationController animated:YES];
        }
            break;
        case 2:
        {
            // In-App
            InAppPurchaseController *inAppController = [[InAppPurchaseController alloc] initWithNibName:@"InAppPurchaseController" bundle:nil];
            [self.navigationController pushViewController:inAppController animated:YES];
        }
            break;
        case 3:
        {
            // Webservice
            WebserviceController *webserviceController = [[WebserviceController alloc] init];
            [self.navigationController pushViewController:webserviceController animated:YES];
        }
            break;
        case 4:
        {
            // Coredata
        }
            break;
        default:
            break;
    }
}

@end
