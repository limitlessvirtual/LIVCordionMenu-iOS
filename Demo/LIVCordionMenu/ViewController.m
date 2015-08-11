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
    
    /*NSArray* types = @[@"cell 1",@"cell 2",@"cell 3",@"cell 4",@"cell 5"];
    
    NSArray* labels = @[@"cell 1",@"cell 2",@"cell 3",@"cell 4",@"cell 5"];
    
    NSArray* descriptions = @[@"cell 1",@"cell 2",@"cell 3",@"cell 4",@"cell 5"];
    
    NSArray* images =  [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"cell1"],
                            [UIImage imageNamed:@"cell2"],
                            [UIImage imageNamed:@"cell3"],
                            [UIImage imageNamed:@"cell4"],
                            [UIImage imageNamed:@"cell5"],
                        
                            nil];*/
    
    NSArray* types = @[@"cell 1",@"cell 2"];
    
    NSArray* labels = @[@"cell 1",@"cell 2"];
    
    NSArray* descriptions = @[@"cell 1",@"cell 2"];
    
    NSArray* images =  [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"cell1"],
                        [UIImage imageNamed:@"cell2"],
                        nil];

    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float x = 0;
    float y = 0;
    float width = screenRect.size.width;
    float height = screenRect.size.height;
    
    CGRect menuFrame = CGRectMake(x, y, width, height);
    
    _accordionMenu = [[LIVCordionMenu alloc] initMenuWithFrame:menuFrame images:images labels:labels descriptions:descriptions types:types];
    _accordionMenu.delegate = self;
    _accordionMenu.fontColor = [UIColor whiteColor];
    _accordionMenu.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    _accordionMenu.descriptionFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    _accordionMenu.cellDisplayFactor = 5;
    _accordionMenu.snapSpeed = 0.8;//self.view.bounds.size.height / 600;
    
    NSLog(@">> %f", self.view.bounds.size.height / 600);
  
    // Other factors
    
    _accordionMenu.bigCellSizeFactor = 1.33;
    _accordionMenu.labelAlignment = NSTextAlignmentLeft;
    _accordionMenu.typeViewActive = YES;
    _accordionMenu.typeViewColor = [UIColor grayColor];
    
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
