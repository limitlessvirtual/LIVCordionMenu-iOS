//
//  LiVAccordion.m
//  Accordion
//
//  Created by Pieter Dirk on 4/20/15.
//  Copyright (c) 2015 Pieter Dirk. All rights reserved.
//

#import "LIVCordionMenu.h"
#import "MenuCell.h"

@interface LIVCordionMenu ()

@property (strong, nonatomic) UIView* container;
@property (strong, nonatomic) UIPanGestureRecognizer* pan;
@property (strong, nonatomic) UITapGestureRecognizer* tap;

@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSArray* labels;

@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) float offsetRemaining;

@property (assign, nonatomic) float lastOffset;
@property (assign, nonatomic) float startY;
@property (assign, nonatomic) float containerWidth;

@property (assign, nonatomic) float cellHeight;
@property (assign, nonatomic) float cellBigHeight;
@property (assign, nonatomic) int cellNumber;

@property (assign, nonatomic) int topPaddingIndex;
@property (assign, nonatomic) int primaryViewIndex;
@property (assign, nonatomic) int secondaryViewIndex;
@property (assign, nonatomic) int bottomPaddingIndex;

@property (assign, nonatomic) CGRect menuFrame;

@end

NSMutableArray* views;
NSMutableArray* oldFrames;

@implementation LIVCordionMenu

- (id)initMenuWithFrame:(CGRect)menuFrame images:(NSArray*)images labels:(NSArray*)labels {
    if (self) {
        // Default properties
        _cellDisplayFactor = 3;
        _fontColor = [UIColor whiteColor];
        _font = [UIFont fontWithName:@"Helvetica" size:25];
        _snapSpeed = 4;
        _cellFilterAlpha = 0.5;
        
        // Arrays
        _labels = [NSArray arrayWithArray:labels];
        _images = [NSArray arrayWithArray:images];
        _cellNumber = (int)[_images count];
        
        // Container
        _menuFrame = menuFrame;
    }
    
    return self;
}

- (void)initInView:(UIView*)view {
    
    _isAnimating = false;
    
    views = [[NSMutableArray alloc] init];
    oldFrames = [[NSMutableArray alloc] init];
    
    _topPaddingIndex = 0;
    _primaryViewIndex = 1;
    _secondaryViewIndex = 2;
    _bottomPaddingIndex = _cellNumber-1;
    
    // Create container
    _container = [[UIView alloc]initWithFrame:_menuFrame];
    _container.clipsToBounds = YES;
    _container.backgroundColor = [UIColor blackColor];
    _containerWidth = _container.bounds.size.width;
    
    // Cell size factor
    _cellDisplayFactor = (_cellDisplayFactor - 1) * 2;
    float cellFactor = _container.frame.size.height / _cellDisplayFactor;
    
    _cellHeight = cellFactor;
    //_cellBigHeight = cellFactor * 2;
    _cellBigHeight = (_cellDisplayFactor/2) * cellFactor;
    
    // Add views to container
    [self addViews];
    
    // Init gesture recogniser
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleScroll:)];
    _pan.minimumNumberOfTouches = 1;
    [_container addGestureRecognizer:_pan];
    
    [view addSubview:_container];
}

- (void)cellTapped:(UITapGestureRecognizer*)sender {
    UIView* view = sender.view;
    _tapped = (int) view.tag;
    
    _tapped -= 2;
    
    if (_tapped < 0) {
        _tapped = _cellNumber - 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(livAccordionMenu:didSelectCell:)]) {
        [self.delegate livAccordionMenu:self didSelectCell:_tapped];
    }
}

- (void)addViews {
    CGFloat positionY = -_cellHeight;
    
    for (int i = 0; i < _cellNumber; i++) {
        int actualIndex = i - 1;
        
        if (actualIndex < 0) {
            actualIndex = _cellNumber-1;
        }
        
        MenuCell* view = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil]objectAtIndex:0];
        
        if (i <= 1) {
            [view setFrame:CGRectMake(0, positionY, _containerWidth, _cellBigHeight)];
            
            if (i == 0) {
                positionY += _cellHeight;
            } else {
                positionY += _cellBigHeight;
            }
        } else {
            [view setFrame:CGRectMake(0, positionY, _containerWidth, _cellHeight)];
            positionY += _cellHeight;
        }
        
        
        view.textLabel.text = _labels[actualIndex];
        view.textLabel.textColor = _fontColor;
        view.textLabel.font = _font;
        [view.imageView setImage:_images[actualIndex]];
        view.cellFilter.alpha = _cellFilterAlpha;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        
        [_container addSubview:view];
        [views addObject:view];
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [view addGestureRecognizer:_tap];
        view.tag = i + 1;
    }
}

- (void)handleScroll:(UIPanGestureRecognizer*)pan {
    float currentY = [pan locationInView:_container].y;
    float offset;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self storeFrames];
        _startY = [pan locationInView:_container].y;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        offset = currentY - _startY;
        _lastOffset = offset;
        
        [self scrollAllViews:offset];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        [self selfScrollWithOffset:_lastOffset];
    }
}

- (void)scrollAllViews:(float)offset {
 
    // Move all cells
    
    //offset = offset/2;
    
    for (int i = 0;i<views.count;i++) {
        MenuCell* view = [views objectAtIndex:i];
        CGRect tmpFrame = view.frame;
        CGRect oldFrame = [[oldFrames objectAtIndex:i] CGRectValue];
        
        if (i != _secondaryViewIndex) {
            if (offset > 0.0 && i == _primaryViewIndex) {
                // Move primary down 2x
                tmpFrame.origin.y = oldFrame.origin.y + (offset * _cellDisplayFactor / 2);
                view.frame = tmpFrame;
            } else {
                // Move everything but secondary 1x
                tmpFrame.origin.y = oldFrame.origin.y + offset;
                view.frame = tmpFrame;
            }
        } else {
            if (offset < 0.0) {
                // Move secondary up 2x
                tmpFrame.origin.y = oldFrame.origin.y + (offset * _cellDisplayFactor / 2);
                view.frame = tmpFrame;
            } else {
                // Move secondary down 1x
                tmpFrame.origin.y = oldFrame.origin.y + offset;
                view.frame = tmpFrame;
            }
        }
    }
    
    // Update view sizes
    MenuCell* primaryView = [views objectAtIndex:_primaryViewIndex];
    MenuCell* secondaryView = [views objectAtIndex:_secondaryViewIndex];
    
    if (offset < 0.0) {

        // Change height secondary
        CGRect oldSecondaryFrame = [[oldFrames objectAtIndex:_secondaryViewIndex] CGRectValue];
        CGRect secondaryFrame = secondaryView.frame;
        secondaryFrame.size.height = oldSecondaryFrame.size.height - (offset * floorf((_cellDisplayFactor - 1.0) / 2.0));
        secondaryView.frame = secondaryFrame;
        
        // Switch
        if (secondaryView.frame.origin.y <= 0) {
            if (!_isAnimating) {
                [self resetFromBottom];
            }
        }
    } else if (offset > 0.0) {
        // Change height primary
        CGRect oldPrimaryFrame = [[oldFrames objectAtIndex:_primaryViewIndex] CGRectValue];
        CGRect primaryFrame = primaryView.frame;
        primaryFrame.size.height = oldPrimaryFrame.size.height - (offset * floorf((_cellDisplayFactor - 1.0) / 2.0));
        primaryView.frame = primaryFrame;
        
        // Switch
        if (primaryView.frame.size.height <= _cellHeight) {
            if (!_isAnimating) {
                [self resetFromTop];
            }
        }
    }
}

- (void)resetFromBottom {
    _startY = [_pan locationInView:_container].y;
    
    // Move top cell
    MenuCell* topPadding = [views objectAtIndex:_topPaddingIndex];
    MenuCell* bottomPadding = [views objectAtIndex:_bottomPaddingIndex];
    
    [topPadding removeFromSuperview];
    
    CGRect topFrame = topPadding.frame;
    topFrame = CGRectMake(topFrame.origin.x, bottomPadding.frame.origin.y + _cellHeight, topFrame.size.width, _cellHeight);
    topPadding.frame = topFrame;
    
    [_container addSubview:topPadding];
    [_container bringSubviewToFront:topPadding];

    // Update indicies
    _topPaddingIndex++;
    _primaryViewIndex++;
    _secondaryViewIndex++;
    _bottomPaddingIndex++;
    
    // Loop around
    if (_topPaddingIndex > _cellNumber-1) {
        _topPaddingIndex = 0;
    }
    
    if (_primaryViewIndex > _cellNumber-1) {
        _primaryViewIndex = 0;
    }
    
    if (_secondaryViewIndex > _cellNumber-1) {
        _secondaryViewIndex = 0;
    }
    
    if (_bottomPaddingIndex > _cellNumber-1) {
        _bottomPaddingIndex = 0;
    }
    
    // Store new frames
    [self storeFrames];
    [self resetPositions];
}

- (void)resetFromTop {
    _startY = [_pan locationInView:_container].y;
    
    // Move bottom cell
    MenuCell* topPadding = [views objectAtIndex:_topPaddingIndex];
    MenuCell* bottomPadding = [views objectAtIndex:_bottomPaddingIndex];
    
    [bottomPadding removeFromSuperview];
    
    CGRect bottomFrame = bottomPadding.frame;
    bottomFrame = CGRectMake(bottomFrame.origin.x, topPadding.frame.origin.y - _cellHeight, bottomFrame.size.width, _cellBigHeight);
    bottomPadding.frame = bottomFrame;
    
    [_container addSubview:bottomPadding];
    [_container sendSubviewToBack:bottomPadding];
    
    // Update indicies
    _topPaddingIndex--;
    _primaryViewIndex--;
    _secondaryViewIndex--;
    _bottomPaddingIndex--;

    // Loop around
    if (_topPaddingIndex < 0) {
        _topPaddingIndex = _cellNumber-1;
    }
    
    if (_primaryViewIndex < 0) {
        _primaryViewIndex = _cellNumber-1;
    }
    
    if (_secondaryViewIndex < 0) {
        _secondaryViewIndex = _cellNumber-1;
    }
    
    if (_bottomPaddingIndex < 0) {
        _bottomPaddingIndex = _cellNumber-1;
    }
    
    // Store new frames
    [self storeFrames];
    [self resetPositions];
}

- (void)selfScrollWithOffset:(float)offset {
    _offsetRemaining = offset;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(performMove:) userInfo:nil repeats:YES];
}

- (void)performMove:(NSTimer*)t {
    if (_offsetRemaining < 0.0) {
        if (_offsetRemaining >= - _cellHeight) {
            _isAnimating = true;
            _offsetRemaining -= _snapSpeed;
            [self scrollAllViews:_offsetRemaining];
        } else {
            // Animation finished
            _isAnimating = false;
            [_timer invalidate];
            
            [self resetFromBottom];
            [self storeFrames];
            [self resetPositions];
        }
    } else {
        if (_offsetRemaining <= _cellHeight) {
            _isAnimating = true;
            _offsetRemaining += _snapSpeed;
            [self scrollAllViews:_offsetRemaining];
        } else {
            // Animation finished
            _isAnimating = false;
            [_timer invalidate];
            
            [self resetFromTop];
            [self storeFrames];
            [self resetPositions];
        }
    }
}

- (void)storeFrames {
    if ([oldFrames count] == 0) {
        for (int i = 0;i<[views count];i++) {
            MenuCell* tmp = [views objectAtIndex:i];
            [oldFrames addObject:[NSValue valueWithCGRect:tmp.frame]];
        }
    } else {
        for (int i = 0;i<[views count];i++) {
            MenuCell* tmp = [views objectAtIndex:i];
            [oldFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:tmp.frame]];
        }
    }
}

- (void)resetPositions {
    CGFloat positionY = -_cellHeight;
    int actualIndex = _topPaddingIndex-1;
    
    for (int i = 0;i<[views count];++i) {
        actualIndex++;
        
        if (actualIndex >= [views count]) {
            actualIndex = 0;
        }
        
        MenuCell* view = [views objectAtIndex:actualIndex];
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = positionY;
        
        if (actualIndex == _topPaddingIndex) {
            positionY += _cellHeight;
            viewFrame.size.height = _cellBigHeight;
        } else if (actualIndex == _primaryViewIndex) {
            positionY += _cellBigHeight;
            viewFrame.size.height = _cellBigHeight;
        } else {
            positionY += _cellHeight;
            viewFrame.size.height = _cellHeight;
        }
        view.frame = viewFrame;
    }
    [self storeFrames];
}

@end
