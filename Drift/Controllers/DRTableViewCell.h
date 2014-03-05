//
//  DRTableViewCell.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRTableViewCell : UITableViewCell

@property (nonatomic, assign, getter = isShowingDisclosureIcon) BOOL showDisclosureIcon;

+(CGFloat)height;

@end
