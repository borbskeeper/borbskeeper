//
//  Borb.h
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Borb : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *borbName;
@property (nonatomic, strong) NSNumber *borbHealth;
@property (nonatomic, strong) NSNumber *borbExperience;
@property (nonatomic, strong) NSNumber *borbLevel; 
@property (nonatomic, strong) PFFileObject *borbPicture;

+ (NSString *)parseClassName;

- (instancetype)initWithInitialStats;

- (void)increaseExperiencePointsBy:(int)XP;

- (void)decreaseExperiencePointsBy:(int)XP;

- (void)increaseHealthPointsBy:(int)HP;

- (void)decreaseHealthPointsBy:(int)HP;

- (void)feedBorb;

@end

NS_ASSUME_NONNULL_END
