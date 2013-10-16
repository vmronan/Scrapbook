//
//  InternetImageView.m
//  InternetImageTest
//
//  Created by Vanessa Ronan on 9/16/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "InternetImageView.h"

@implementation InternetImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithURLFromString:(NSString *)url andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                                             delegate:self];
        self.webData = [[NSMutableData alloc] initWithCapacity:0];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Make sure webData is empty so we can store the new response there
    self.webData = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Save response data
    [self.webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Show downloaded image
    [self setImage:[UIImage imageWithData:self.webData]];
    [self.target performSelector:self.action withObject:[UIImage imageWithData:self.webData]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
