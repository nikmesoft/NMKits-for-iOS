//
//  WebserviceController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "WebserviceController.h"
#import "Webservice.h"
#import "MBProgressHUD.h"

#import <NMKits/NMUIHelper.h>

@interface WebserviceController ()
{
    Webservice *_webservice;
}

@end

@implementation WebserviceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"RESTful + JSON WS";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webservice = [[Webservice alloc] init];
    [self setXib];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadWebservice:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private's method

- (void)setXib
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadWebservice:)];
}

- (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withTag:(NSInteger)tag withTitleButtonCancel:(NSString *)titleButtonCancel andTitleButtonOther:(NSString *)otherButtonTitles
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:titleButtonCancel otherButtonTitles:otherButtonTitles, nil];
    alertView.tag = tag;
    [alertView show];
    alertView = nil;
    
}

#pragma mark - Action


- (IBAction)reloadWebservice:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_webservice getFoodDetailwithFoodID:@"117" withUserID:@"0" withKey:@"GetFood" completionHandler:^(BOOL successfully, NSError *error, NSObject *data, NSString *key) {
        if ([key isEqualToString:@"GetFood"]) {
            if (successfully) {
                [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:[NSString stringWithFormat:@"%@",data] delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
            } else {
                [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:error.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
            }
        }
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

@end
