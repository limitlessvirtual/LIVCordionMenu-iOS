//
//  menuCell.h
//  Accordion
//
//  Created by Pieter Dirk on 5/23/15.
//  Copyright (c) 2015 Pieter Dirk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UIView

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *cellFilter;

@end
