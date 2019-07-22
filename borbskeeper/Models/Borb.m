//
//  Borb.m
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "Borb.h"
#import "PFObject+Subclass.h"

@implementation Borb

@dynamic borbHealth;
@dynamic borbExperience;
@dynamic borbPicture;

static int MAX_HP = 100;

+ (NSString *)parseClassName {
    return @"Borb";
}

- (instancetype)initWithInitialStats {
    self = [super init];
    
    if (self) {
        self.borbHealth = [NSNumber numberWithInt:MAX_HP];
        self.borbExperience = @0;
        
        UIImage *defaultImage = [UIImage imageNamed:@"borb_original"];
        NSData *imageData = UIImagePNGRepresentation(defaultImage);
        self.borbPicture = [PFFileObject fileObjectWithName:@"borb.png" data:imageData];
        
    }
    
    return self;
}



@end
