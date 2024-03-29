//
//  SDSelectableCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDNestedTableViewController;

typedef enum
{
    Unchecked = 0,
    Checked,
    Halfchecked,
}
SelectableCellState;

@interface SDSelectableCell : UITableViewCell
{
    
    
    IBOutlet UIView *tapTransitionsOverlay;
}
@property (strong, nonatomic) IBOutlet UILabel *detailText;

@property (nonatomic) IBOutlet UILabel *itemText;

@property (nonatomic, assign) SDNestedTableViewController *parentTable;
@property (nonatomic) SelectableCellState selectableCellState;

- (SelectableCellState) toggleCheck;
- (void) check;
- (void) uncheck;
- (void) halfCheck;

- (void) styleEnabled;
- (void) styleDisabled;
- (void) styleHalfEnabled;
- (void) tapTransition;

- (void) setupInterface;

@end
