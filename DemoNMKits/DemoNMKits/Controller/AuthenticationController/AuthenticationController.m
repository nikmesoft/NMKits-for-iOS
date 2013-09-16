//
//  AuthenticationController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "AuthenticationController.h"
#import <NMKits/NMShareKit.h>
#import <NMKits/NMUIHelper.h>

@interface AuthenticationController () <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation AuthenticationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Social Authentication";
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
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter",@"Google Plus", nil];
}

- (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withTag:(NSInteger)tag withTitleButtonCancel:(NSString *)titleButtonCancel andTitleButtonOther:(NSString *)otherButtonTitles
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:titleButtonCancel otherButtonTitles:otherButtonTitles, nil];
    alertView.tag = tag;
    [alertView show];
    alertView = nil;
    
}

- (void)showDialog:(NSString*)message
{
    if(message != nil)
    {
        [NMUIHelper showAlertWithTitle:@"NMShareKit" message:message delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
    }
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
        {
            // Facebook authentication
            NSArray *permissions = [NSArray arrayWithObjects:@"email",@"user_birthday",@"user_location", nil];
            NSArray *userFields = [NSArray arrayWithObjects:@"uid",@"email",@"pic_big", nil];
            // if userFields = nill, NMkits will use default info
            // details of all properties https://developers.facebook.com/docs/reference/fql/user
            
            [[NMShareKit sharedManager] fbGetProfileWithPermissions:permissions userFields:userFields completionHandler:^(BOOL sucessfully,NSError *error,NSDictionary* dataDict)
             {
                 if(sucessfully)
                 {
                     DBG(@"%@",dataDict);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:[NSString stringWithFormat:@"%@",dataDict] waitUntilDone:NO];
                 } else {
                     DBG(@"%@",error.userInfo);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:error.description waitUntilDone:NO];
                 }
                 
             }];
        }
            break;
        case 1:
        {
            // Twitter authentication
            [[NMShareKit sharedManager] twGetProfileWithCompletionHandler:^(BOOL sucessfully,NSError *error,NSDictionary* dataDict)
             {
                 if(sucessfully)
                 {
                     DBG(@"%@",dataDict);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:[NSString stringWithFormat:@"%@",dataDict] waitUntilDone:NO];
                 } else {
                     DBG(@"%@",error.userInfo);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:error.description waitUntilDone:NO];
                 }
                 
             }];
        }
            break;
        case 2:
        {
            // Googleplus authentication
            [[NMShareKit sharedManager] gPlusGetProfileWithCompletionHandler:^(BOOL sucessfully,NSError *error,NSDictionary* dataDict)
             {
                 if(sucessfully)
                 {
                     DBG(@"%@",dataDict);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:[NSString stringWithFormat:@"%@",dataDict] waitUntilDone:NO];
                 } else {
                     DBG(@"%@",error.userInfo);
                     [self performSelectorOnMainThread:@selector(showDialog:) withObject:error.description waitUntilDone:NO];
                 }
                 
             }];
        }
            break;
        default:
            break;
    }
}

@end
