//
//  DRRunTableViewCell.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTableViewCell.h"
#import "DRModel.h"

@interface DRRunTableViewCell : DRTableViewCell

+(CGFloat)driftMargin;
+(CGFloat)lengthMargin;
+(CGFloat)courseMargin;

-(void)setRun:(DRRun *)run;

@end
