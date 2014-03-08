//
//  DRRunTableViewCell.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDraggableTableViewCell.h"
#import "DRModel.h"

@interface DRRunTableViewCell : DRDraggableTableViewCell

@property (nonatomic, strong, readonly) NSString *runID;

+(CGFloat)driftMargin;
+(CGFloat)lengthMargin;
+(CGFloat)courseMargin;

-(void)setRun:(DRRun *)run;

@end
