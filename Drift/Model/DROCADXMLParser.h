//
//  DROCADXMLParser.h
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DROCADXMLParser : NSObject

+(void)parseXMLData:(NSData *)data;

@end
