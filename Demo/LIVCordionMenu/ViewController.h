//
//  ViewController.h
//  com.limitlessvirtual.livaccordion
//
//  Created by Pieter-Dirk on 5/26/15.
//  Copyright (c) 2015 Limitless Virtual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIVCordionMenu.h"

@interface ViewController : UIViewController <LIVCordionDelegate>

@property(strong, nonatomic) LIVCordionMenu* accordionMenu;

@end

