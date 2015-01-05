//
//  BFPlayer.m
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFPlayer.h"

@implementation BFPlayer

- (id)initWithName:(NSString *)name level:(int)level rpgClass:(RPGClass)rpgClass
{
    if((self = [super init]))
    {
        self.name = name;
        self.level = level;
        self.rpgClass = rpgClass;
    }
    
    return self;
}

- (void)dealloc
{
    self.name = nil;
    //free((__bridge void *)(self));
}

@end
