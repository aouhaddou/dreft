//
//  DRPathTableViewCell.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDraggableTableViewCell.h"
#import "DRModel.h"

@interface DRPathTableViewCell : DRDraggableTableViewCell

@property (nonatomic, strong) UILabel *lengthLabel;
@property (nonatomic, strong) NSString *pathID;

-(void)setPath:(DRPath *)path;

@end
