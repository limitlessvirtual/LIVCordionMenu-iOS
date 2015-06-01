//
//  ViewController.m
//  com.limitlessvirtual.livaccordion
//
//  Created by Pieter-Dirk on 5/26/15.
//  Copyright (c) 2015 Limitless Virtual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* labels = @[@"cell1",@"cell2",@"cell3",@"cell4",@"cell5"];
    NSArray* images =  [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"cell1"],
                            [UIImage imageNamed:@"cell2"],
                            [UIImage imageNamed:@"cell3"],
                            [UIImage imageNamed:@"cell4"],
                            [UIImage imageNamed:@"cell5"],
                            nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float x = 0;
    float y = 0;
    float width = screenRect.size.width;
    float height = screenRect.size.height;
    
    CGRect menuFrame = CGRectMake(x, y, width, height);
    
    _accordionMenu = [[LIVCordionMenu alloc] initMenuWithFrame:menuFrame images:images labels:labels];
    _accordionMenu.delegate = self;
    _accordionMenu.fontColor = [UIColor whiteColor];
    _accordionMenu.font = [UIFont fontWithName:@"Helvetica" size:25];
    _accordionMenu.cellDisplayFactor = 3;
    _accordionMenu.snapSpeed = 4;
    
    [_accordionMenu initInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Delegates

- (void)livAccordionMenu:(LIVCordionMenu*)accordionMenu didSelectCell:(int)index {
    NSLog(@"Tapped Index: %d", index);
}

@end
