//
//  Task.m
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "Task.h"

@implementation Task

@dynamic taskName;
@dynamic dueDate;
@dynamic taskDescription;
@dynamic author;
@dynamic completed;
@dynamic verified;
@dynamic posted;

+ (NSString *)parseClassName {
    return @"Task";
}

+ (Task*)createTask:(NSString*)title withDescription:(NSString*)description withDueDate:(NSDate*)date{
    
    Task *newTask = [Task new];
    newTask.author = [PFUser currentUser];
    newTask.taskName = title;
    newTask.taskDescription = description;
    newTask.dueDate = date;
    newTask.completed = NO; 
    newTask.verified = NO;
    newTask.posted = NO;
    
    return newTask;
}

+ (void)editTask:(Task*)task withTitle:(NSString*)title withDescription:(NSString*)description withDueDate:(NSDate*)date{
    task.taskName = title;
    task.taskDescription = description;
    task.dueDate = date;
}

+ (void)markTaskAsFinished:(Task*)task{
    task.completed = YES;
}

+ (void)markTaskAsUnfinished:(Task*)task{
    task.completed = NO;
}
@end
