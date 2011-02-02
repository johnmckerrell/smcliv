//
//  HTTPOperation.m
//  smcliv
//
//  Created by John McKerrell on 15/10/2010.
//  Copyright 2010 MKE Computing Ltd. All rights reserved.
//

#import "HTTPTask.h"


@implementation HTTPTask

@synthesize connection = _connection;
@synthesize url = _url;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;
@synthesize active = _active;
@synthesize failed = _failed;
@synthesize percentage = _percentage;
@synthesize contentLength = _contentLength;
@synthesize httpData = _httpData;
@synthesize errorDescription = _errorDescription;
@synthesize target = _target;
@synthesize action = _action;
@synthesize lastModifiedDate = _lastModifiedDate;

-(id)initWithURL:(NSURL*)url target:(id)target action:(SEL)action {
    if (self == [super init]) {
        self.url = url;
        NSLog(@"%@", url);
        self.target = target;
        self.action = action;
    }
    return self;
}

- (void)start {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:self.url
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:30.0];
    if (self.lastModifiedDate) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];  
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";  
        df.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];  
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [theRequest setValue:[df stringFromDate:self.lastModifiedDate] forHTTPHeaderField:@"If-Modified-Since"];
    }
    self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    
    if (self.connection) {
        self.active = YES;
        self.httpData = [NSMutableData data];
    } else {
        self.finished = YES;
        self.failed = YES;
    }

}

-(void)finishedWithError:(NSString*)errorDescription {
    if (errorDescription) {
        self.errorDescription = errorDescription;
        self.failed = YES;
        [self.connection cancel];
    }
    self.active = NO;
    self.finished = YES;
    
    if (self.target) {
        [self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
    }
}

- (void)cancel {
    if (self.finished) {
        return;
    }
    if (self.connection) {
        [self.connection cancel];
    }
    self.cancelled = YES;
    self.finished = YES;
    self.active = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    [self.httpData setLength:0];
    self.contentLength = [response expectedContentLength];
    self.percentage = 0;
    if ([response statusCode] == 304 && self.lastModifiedDate) {
        return;
    }
    if ([response statusCode] != 200) {
        [self finishedWithError:@"Received an error from the server"];
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    //[receivedData appendData:data];
    [self.httpData appendData:data];
    if (self.contentLength) {
        NSUInteger newPercentage = ((float)[self.httpData length] / (float)self.contentLength) * 100.0;
        if (newPercentage != self.percentage) {
            self.percentage = newPercentage;
        }
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    // receivedData is declared as a method instance elsewhere
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
    [self finishedWithError:@"Problem downloading the file."];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    // release the connection, and the data object
        
    [self finishedWithError:nil];
}


-(void)dealloc {
    self.url = nil;
    self.connection = nil;
    self.httpData = nil;
    self.errorDescription = nil;
    self.target = nil;
    self.action = nil;
    
    [super dealloc];
}

@end
