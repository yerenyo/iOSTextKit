//
//  TouchImageView.m
//  MultiTouchDemo
//
//  Created by Jason Beaver on 5/29/08.
//  Copyright 2008 Apple Inc.. All rights reserved.
//
#import "TouchImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "TouchImageView_Private.h"
#include <execinfo.h>
#include <stdio.h>

@implementation TouchImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originalTransform = CGAffineTransformIdentity;
        touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.exclusiveTouch = YES;
        
        CATiledLayer *tiled=(CATiledLayer *)[self layer];
        tiled.borderColor = [UIColor clearColor].CGColor;
        tiled.borderWidth = 3.0;
        tiled.shouldRasterize=YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
	isTouchMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
    self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
	if(!isTouchMove)isTouchMove = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];

    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];//
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)dealloc
{
	if (touchBeginPoints!=NULL) {
		CFRelease(touchBeginPoints);
	}
    
    
    [super dealloc];
}

@end
