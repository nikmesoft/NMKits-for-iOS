//
//  InAppPurchaseController.m
//  DemoNMKits
//
//  Created by Nikmesoft on 9/10/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import "InAppPurchaseController.h"
#import "MBProgressHUD.h"

#import <NMKits/NMInAppPurchaseKit.h>
#import <NMKits/NMUIHelper.h>

#define IDENTIFIER @"InAppPurchase_Products.plist"

@interface InAppPurchaseController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSNumberFormatter * priceFormatter;

@end

@implementation InAppPurchaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"In-App";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setXib];
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    
    UIBarButtonItem *restoreButton = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoTapped:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:restoreButton,infoBarButton, nil];
}

- (void)productPurchased:(NSNotification *)notification
{
    // get Products from notification
    NSString *productIdentifier = notification.object;
    [self.products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}

- (void)reload
{
    // Get In-App products and reload table
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.products = nil;
    [self.tableView reloadData];
    
    [[NMInAppPurchaseKit sharedInstance] requestProductsIdentifiersFromPath:IDENTIFIER completionHandler:^(BOOL successfully, NSError *errror, NSMutableArray *products) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(successfully)
        {
            self.products = products;
            for (NSString *s in products) {
                DBG(@"%@",s);
            }
            [self.tableView reloadData];
        } else {
            [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:errror.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
        }
    }];
}

#pragma mark - Action

- (IBAction)restoreTapped:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NMInAppPurchaseKit sharedInstance] restoreCompletedTransactionsWithCompletionHandler:^(BOOL successfully, NSError *errror, NSMutableArray *products) {
        if (successfully) {
            [self.tableView reloadData];
        } else {
            [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:errror.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (IBAction)infoTapped:(id)sender
{
    [NMUIHelper showAlertWithTitle:@"Demo Account" message:@"inapp@nikmesoft.com \n Abcde12345-"
                delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
}


- (IBAction)buyButtonDidPressed:(id)sender
{
    // Buy(Purchase) product
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = self.products[buyButton.tag];
    
    [[NMInAppPurchaseKit sharedInstance] purchaseProduct:product compleHandler:^(BOOL successfully, NSError *errror, SKProduct *product) {
        if (successfully) {
            [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:[NSString stringWithFormat:@"Purchased %@",product.localizedTitle] delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
        } else {
            [NMUIHelper showAlertWithTitle:@"DemoNMKits" message:errror.description delegate:nil tag:0 cancelButtonTitle:@"OK" okButtonTitle:nil];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SKProduct *product = (SKProduct *)self.products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    [self.priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [self.priceFormatter stringFromNumber:product.price];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyButton.frame = CGRectMake(0,0,72,37);
    [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
    buyButton.tag = indexPath.row;
    [buyButton addTarget:self action:@selector(buyButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = buyButton;
    
    return cell;
}

@end
