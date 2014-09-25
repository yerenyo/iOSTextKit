//
//  PCMObject.h
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-25.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDXMLElement;
@protocol PCMObject<NSObject>
@required
//- (id) initWithNote:(DDXMLElement *)xmlnode;
- (id)initByRandom;
//- (DDXMLElement *)saveToXml;
@end
