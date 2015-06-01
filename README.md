#LiVCordionMenu


An infinitely scrolling menu (both up and down) with and an overlapping cell animation. The menu is customizable in terms of number of cells, their images, how many cells are displayed on the screen etc. 
The menu's frame can be set to any size. 

<img src="http://i.imgur.com/Rgex3FB.gif" width="200px;">
<img src="http://i.imgur.com/hxYLpFZ.gif" width="200px;">

**Note**: An <a href="https://github.com/limitlessvirtual/LIVCordionMenu-Android">Android Version</a> is also available (coming soon).

##Setup

You can either:

1. Copy the the **LIVCordionMenu** directly into your Project
2. Include the following cocoapod (preferred):

```
pod 'LIVCordionMenu'
```

##Usage

Import the required header file:

```objective-c
#import <LIVCordionMenu/LIVCordionMenu.h>

//or without pod

#import "LIVCordionMenu.h"
```

Create the LIVCordionMenu with an array of images, labels and a frame:

```objective-c

//Arrays
NSArray* labels = @[@"cell1",@"cell2",@"cell3",@"cell4",@"cell5"];
NSArray* images =  [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"cell1"],
                        [UIImage imageNamed:@"cell2"],
                        [UIImage imageNamed:@"cell3"],
                        [UIImage imageNamed:@"cell4"],
                        [UIImage imageNamed:@"cell5"],
nil];
    
//Frame (fill view example)
CGRect screenRect = [[UIScreen mainScreen] bounds];
    
float x = 0;
float y = 0;
float width = screenRect.size.width;
float height = screenRect.size.height;
    
CGRect menuFrame = CGRectMake(x, y, width, height);
    
_accordionMenu = [[LiVAccordion alloc] initMenuWithFrame:menuFrame images:images labels:labels];
_accordionMenu.delegate = self;

//Set optional properties
_accordionMenu.fontColor = [UIColor whiteColor];
_accordionMenu.font = [UIFont fontWithName:@"Helvetica" size:25];
_accordionMenu.cellDisplayFactor = 3;
_accordionMenu.snapSpeed = 4;

//Add the menu to the desired view
[_accordionMenu initInView:self.view];

```

###Initialisation

Initialising the accordion menu:

**At a certain point in a view:**

```objective-c
[[LIVCordionMenu alloc] initMenuWithFrame:menuFrame images:images labels:labels];
```

###Delegates

The following delegate is available:

```objective-c

//User selected an accordion
- (void)livAccordionMenu:(LIVCordion*)accordionMenu didSelectCell:(int)index {
    NSLog(@"Tapped Index: %d", index);
}

```

##Customizable Properties

| Property               | Type     | Description                                                            | Default Value |
|------------------------|----------|------------------------------------------------------------------------|---------------|
| images                 | NSArray* | Names of images for each accordion menu item.                          | -             |
| labels                 | NSArray* | Names of labels for each accordion menu item.                          | -             |
| cellDisplayFactor      | int      | Number of cells shown on the screen at one time.                       | 3             |
| cellFilterAlpha        | float    | Alpha value of the cell background filter.                             | 0.5           |
| fontColor              | UIColor* | Color of the labels.                                                   | whiteColor    |
| font                   | UIFont   | Font object for font family and color.                                 | Helvetica, 25 |
| snapSpeed              | float    | Speed at which cells snap to the top when the user lifts their finger  | 4             |
| isAnimating            | BOOL     | Flag whether the animation is currently hiding or showing              | -             |

**Note**: The number of images/labels should be 2 greater than cellDisplayFactor.

##Requirements

`ARC`, `iOS 8.0+`, `Xcode 6+`

##Upcoming Features

* Add support for displaying less than 2 cells on the screen
* Cell opacity animation
* Text positioning
* Text resizing animation
* Description under label
* Have an idea? Pop an email to info@limitlessvirtual.com


