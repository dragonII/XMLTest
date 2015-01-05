//
//  BFParty.m
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFParty.h"

@implementation BFParty

- (id)init
{
    if((self = [super init]))
    {
        self.players = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.players = nil;
}

@end
