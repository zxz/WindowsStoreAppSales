//
//  SDSelectableCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDSelectableCell.h"

@implementation SDSelectableCell

@synthesize itemText, parentTable, selectableCellState;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        selectableCellState = Unchecked;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupInterface];
}

- (void) setupInterface
{
    [self setClipsToBounds: YES];
    
    CGRect frame = self.itemText.frame;
    self.itemText.frame = frame;
}

- (SelectableCellState) toggleCheck
{
    if (selectableCellState == Checked)
    {
        selectableCellState = Unchecked;
        [self styleDisabled];
    }
    else
    {
        selectableCellState = Checked;
        [self styleEnabled];
    }
    return selectableCellState;
}

- (void) check
{
    selectableCellState = Checked;
    [self styleEnabled];
}

- (void) uncheck
{
    selectableCellState = Unchecked;
    [self styleDisabled];
}

- (void) halfCheck
{
    selectableCellState = Halfchecked;
    [self styleHalfEnabled];
}

- (void) styleEnabled
{
    itemText.alpha = 1.0;
    
//    self.backgroundView.backgroundColor = UIColorFromRGBWithAlpha(0x0d2e4d, 1.0);
//    self.backgroundView.alpha = 0.7;
}

- (void) styleDisabled
{
//    itemText.alpha = 0.4;
//    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
//    self.backgroundView.alpha = 0.5;
}

- (void) styleHalfEnabled
{
//    itemText.alpha = 0.7;
//    self.backgroundView.backgroundColor = UIColorFromRGBWithAlpha(0x081c2f, 1.0);
//    self.backgroundView.alpha = 0.7;
}

- (void) tapTransition
{
//    tapTransitionsOverlay.alpha = 1.0;
//    [UIView beginAnimations:@"tapTransition" context:nil];
//    [UIView setAnimationDuration:0.8];
//    tapTransitionsOverlay.alpha = 0.0;
//    [UIView commitAnimations];
}

@end
