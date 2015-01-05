//
//  BFPartyParser.h
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFParty;

@interface BFPartyParser : NSObject

+ (BFParty *)loadParty;
+ (void)saveParty:(BFParty *)party;

@end
