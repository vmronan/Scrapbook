//
//  InternetImageView.h
//  InternetImageTest
//
//  Created by Vanessa Ronan on 9/16/13.
//  Copyright (c) 2013 Vanessa Ronan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetImageView : NSObject <NSURLConnectionDataDelegate>

@property NSURLConnection *urlConnection;
@property NSMutableData *webData;
@property id target;
@property SEL action;

- (id)initWithURLFromString:(NSString *)url;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
