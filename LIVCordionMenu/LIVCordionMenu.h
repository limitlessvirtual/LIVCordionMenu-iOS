//
//  LiVAccordion.h
//  Accordion
//
//  Created by Pieter-Dirk on 4/20/15.
//  Copyright (c) 2015 Limitless Virtual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LIVCordionDelegate;

@interface LIVCordionMenu : UIView

// Delegate
@property (nonatomic, assign) id<LIVCordionDelegate> delegate;

// Cell properties
@property (assign, nonatomic) int cellDisplayFactor;    // Factor of cells displayed on screen
@property (strong, nonatomic) UIColor *fontColor;       // Font color of text
@property (assign, nonatomic) UIFont *font;             // Font size and family of text
@property (assign, nonatomic) UIFont *descriptionFont;             // Font size and family of description
@property (assign, nonatomic) NSTextAlignment labelAlignment; // Alignment of text
@property (assign, nonatomic) Boolean typeViewActive;   // Upper right box
@property (assign, nonatomic) UIColor *typeViewColor;   // Upper right box color

@property (assign, nonatomic) float snapSpeed;          // Speed at which the cell snap animation occurs
@property (assign, nonatomic) int tapped;               // Cell which was last tapped
@property (assign, nonatomic) BOOL isAnimating;         // True if menu is currently completing snap animation
@property (assign, nonatomic) float cellFilterAlpha;    // Alpha value of the cell background filter

@property (assign, nonatomic) float bigCellSizeFactor;  // Makes big cell larger than half of the screen

// Init functions
- (id)initMenuWithFrame:(CGRect)menuFrame images:(NSArray*)images labels:(NSArray*)labels descriptions:(NSArray*)descriptions types:(NSArray*)types; // Intialise the menu at a certain point with a certian size
- (void)initInView:(UIView*)view;                         // Place menu in a paticular view

@end

@protocol LIVCordionDelegate<NSObject>
@optional

- (void)livAccordionMenu:(LIVCordionMenu*)accordionMenu didSelectCell:(int)index; // Cell selected

@end

