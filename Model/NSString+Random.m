//
//  NSString+Random.m
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-19.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "NSString+Random.h"
@implementation NSString (Random)
+ (NSString *) stringWithRandom{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    dateFormatter.dateFormat    = @"yyMMddHHmmss";
//    int num = rand()%10000;
//    NSString *dateStr  = [dateFormatter stringFromDate:date];
//    return [NSString stringWithFormat:@"%@%04d", dateStr, num];
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, cfuuid);
    NSString *cfuuidString = [NSString stringWithString:(NSString *)cfstring];
    CFRelease(cfuuid);
    CFRelease(cfstring);
    return cfuuidString;
}
@end
