//
//  DRDraggableTableViewCell.h
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTableViewCell.h"

@class DRDraggableTableViewCell;
@protocol DRDraggableTableViewCellDelegate <NSObject>

-(void)tableViewCellDidSelectDeleteButton:(DRDraggableTableViewCell *)cell;

@end

@interface DRDraggableTableViewCell : DRTableViewCell

@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, strong) UIView *panContentView;
@property (nonatomic, weak) id<DRDraggableTableViewCellDelegate> delegate;

@end
