//
//  FriendRequest.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

@dynamic recipient;
@dynamic sender;

+ (NSString *)parseClassName {
    return @"FriendRequest";
}

+ (void)acceptFriendRequest{
    
}

+ (void)rejectFriendRequest{
    
}

+ (FriendRequest*)createFriendRequestWithSender:(User*)sender withRecipient:(User*)recipient{
    FriendRequest *newRequest = [FriendRequest new];
    newRequest.sender = sender;
    newRequest.recipient = recipient;
    
    return newRequest;
}


@end
