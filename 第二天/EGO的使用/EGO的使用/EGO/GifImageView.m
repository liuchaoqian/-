//
//  GifImageView.m
//  Weather
//
//  Created by pro on 12-7-13.
//  Copyright (c) 2012年 mac All rights reserved.
//


#import "GifImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GifImageView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
        
        gifProperties = [[NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], (CFDictionaryRef)gifProperties);
        
        count =CGImageSourceGetCount(gif);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

-(void)play
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.layer.contents = (id)ref;
    CFRelease(ref);
}

- (void)dealloc
{
    CFRelease(gif);
    [gifProperties release];
    [super dealloc];
}

- (void)stopGif
{
    [timer invalidate];
    timer = nil;
}

@end