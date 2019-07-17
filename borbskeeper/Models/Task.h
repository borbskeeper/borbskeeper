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
@property (nonatomic, strong) NSDate *dueDate;

@end

NS_ASSUME_NONNULL_END
