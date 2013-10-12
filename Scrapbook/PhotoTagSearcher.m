//
//  ISIntagramTagSearcher.m
//  InstaSearch
//
//  Created by Vanessa Ronan on 9/18/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import "PhotoTagSearcher.h"

@implementation PhotoTagSearcher

- (id)initWithQuery:(NSURL *)queryURL target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        // initialization code here
        self.target = target;
        self.action = action;
        self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:queryURL] delegate:self];
    }
    return self;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    
    [self.target performSelector:self.action withObject:response];
}


@end
