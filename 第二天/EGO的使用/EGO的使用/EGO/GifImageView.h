//
//  GifImageView.h
//  Weather
//
//  Created by pro on 12-7-13.
//  Copyright (c) 2012年 mac All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifImageView : UIView 
{
    CGImageSourceRef gif; // 保存gif动画
    NSDictionary *gifProperties; // 保存gif动画属性
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
    NSTimer *timer; // 播放gif动画所使用的timer
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;
- (void)stopGif;

@end
