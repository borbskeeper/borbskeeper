//
//  Task.h
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic) BOOL verified;
@property (nonatomic) BOOL posted;

+ (Task*)createTask:(NSString*)title withDescription:(NSString*)description withDueDate:(NSDate*)date;


@end

NS_ASSUME_NONNULL_END
