//
//  CEReachabilityManager.m
//  Cencrypt
//
//  Created by Ingic on 14/04/2014.

#import "CEReachabilityManager.h"

@implementation CEReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (CEReachabilityManager *)sharedManager {
    static CEReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[CEReachabilityManager sharedManager] reachability] isReachable];
}


#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}
@end
