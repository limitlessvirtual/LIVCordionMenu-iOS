//
//  menuCell.h
//  Accordion
//
//  Created by Pieter-Dirk on 4/20/15.
//  Copyright (c) 2015 Limitless Virtual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UIView

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *typeView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;


@end
