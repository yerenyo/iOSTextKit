//
//  PCMImportObject.m
//  PDFCreator
//
//  Created by Jinyou Gu on 13-1-14.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "PCMImportObject.h"
#import "NSString+Random.h"
//@interface PCMImportObject(){
//}
//
//@end
@implementation PCMImportObject
@synthesize rect=_rect;
@synthesize transform=_transform;
@synthesize type=_type;
@synthesize ref=_ref;
@synthesize bgColor=_bgColor;
- (id)initByRandom{
    self = [self init];
    if (self) {
        _ref = [[NSString stringWithRandom] copy];
        _transform = CGAffineTransformIdentity;
    }
    return self;
}
- (void)dealloc{
    [_ref release];
    [_bgColor release];
    [_type release];
    [super dealloc];
}
#pragma mark - publich function

@end
