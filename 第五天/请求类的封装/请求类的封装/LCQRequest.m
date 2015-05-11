//
//  LCQRequest.m
//  请求类的封装
//
//  Created by qf on 15/5/10.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQRequest.h"

@implementation LCQRequest

-(id)initRequestWithURL:(NSURL *)url
{
    if (self = [super init]) {
        requestURL = url;
        requestData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)startAsynchronous
{
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:requestURL];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    requestData.length = 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [requestData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.responseData = requestData;
    self.responseString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    if ([_delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [_delegate requestDidFinish:self.responseData];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(requestFaild:)]) {
        [_delegate requestFaild:self];
    }
}


@end




