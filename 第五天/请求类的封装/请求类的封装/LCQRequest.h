//
//  LCQRequest.h
//  请求类的封装
//
//  Created by qf on 15/5/10.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCQRequestDelegate;

@interface LCQRequest : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSURL * requestURL;
    NSMutableData * requestData;
}
@property (strong, nonatomic) id<LCQRequestDelegate> delegate;
@property (strong, nonatomic) NSMutableData * responseData;
@property (strong, nonatomic) NSString * responseString;

-(id)initRequestWithURL:(NSURL *)url;
-(void)startAsynchronous;

@end

@protocol LCQRequestDelegate <NSObject>

-(void)requestDidFinish:(NSData *)data;
-(void)requestFaild:(LCQRequest *)request;

@end