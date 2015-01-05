//
//  BFPlayer.h
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RPGClassFighter,
    RPGClassRogue,
    RPGClassWizard
} RPGClass;

@interface BFPlayer : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) int level;
@property (assign, nonatomic) RPGClass rpgClass;

- (id)initWithName:(NSString *)name level:(int)level rpgClass:(RPGClass)rpgClass;

@end
