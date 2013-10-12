//
//  ISIntagramTagSearcher.h
//  InstaSearch
//
//  Created by Vanessa Ronan on 9/18/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoTagSearcher : NSObject

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;
@property id target;
@property SEL action;

- (id)initWithQuery:(NSURL *)queryURL target:(id)target action:(SEL)action;
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
