//
//  HTTPOperation.h
//  smcliv
//
//  Created by John McKerrell on 15/10/2010.
//  Copyright 2010 MKE Computing Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPTask : NSOperation {
    NSURL *_url;
    NSURLConnection *_connection;
    BOOL _finished, _cancelled, _active, _failed;
    NSInteger _percentage, _contentLength;
    NSMutableData *_httpData;
    NSString *_errorDescription;
    id _target;
    SEL _action;
    NSDate *_lastModifiedDate;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL failed;
@property (nonatomic, assign) NSInteger percentage;
@property (nonatomic, assign) NSInteger contentLength;
@property (nonatomic, retain) NSMutableData *httpData;
@property (nonatomic, retain) NSString *errorDescription;
@property (nonatomic, retain) id target;
@property (nonatomic) SEL action;
@property (nonatomic, retain) NSDate *lastModifiedDate;

-(id)initWithURL:(NSURL*)url target:(id)target action:(SEL)action;

-(void)start;

-(void)finishedWithError:(NSString*)errorDescription;

-(void)cancel;

@end
