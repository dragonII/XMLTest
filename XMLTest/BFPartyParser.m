//
//  BFPartyParser.m
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFPartyParser.h"
#import "BFParty.h"
#import "GDataXMLNode.h"
#import "BFPlayer.h"

@implementation BFPartyParser

/*
+ (NSString *)dataFilePath:(BOOL)forSave
{
    return [[NSBundle mainBundle] pathForResource:@"Party" ofType:@"xml"];
}
 */

+ (NSString *)dataFilePath:(BOOL)forSave
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"Party.xml"];
    if(forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
    {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"Party" ofType:@"xml"];
    }
}

+ (void)saveParty:(BFParty *)party
{
    GDataXMLElement *partyElement = [GDataXMLNode elementWithName:@"Party"];
    
    for(BFPlayer *player in party.players)
    {
        GDataXMLElement *playerElement = [GDataXMLNode elementWithName:@"Player"];
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:player.name];
        GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level" stringValue:[NSString stringWithFormat:@"%d", player.level]];
        NSString *classString;
        if(player.rpgClass == RPGClassFighter)
            classString = @"Fighter";
        else if (player.rpgClass == RPGClassRogue)
            classString = @"Rogue";
        else if (player.rpgClass == RPGClassWizard)
            classString = @"Wizard";
        
        GDataXMLElement *classElement = [GDataXMLNode elementWithName:@"Class" stringValue:classString];
        
        [playerElement addChild:nameElement];
        [playerElement addChild:levelElement];
        [playerElement addChild:classElement];
        [partyElement addChild:playerElement];
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:true];
    NSLog(@"saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
}

+ (BFParty *)loadParty
{
    NSString *filePath = [self dataFilePath:false];
    NSLog(@"filePath: %@", filePath);
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc == nil)
    {
        return nil;
    }
    
    NSLog(@"%@", doc.rootElement);
    
    BFParty *party = [[BFParty alloc] init];
    //NSArray *partyMembers = [doc.rootElement elementsForName:@"Player"];
    NSArray *partyMembers = [doc nodesForXPath:@"//Party/Player" error:nil];
    for(GDataXMLElement *partyMember in partyMembers)
    {
        NSString *name;
        int level;
        RPGClass rpgClass;
        
        // Name
        NSArray *names = [partyMember elementsForName:@"Name"];
        if([names count] > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *)[names objectAtIndex:0];
            name = [firstName stringValue];
        } else {
            continue;
        }
        
        // Level
        NSArray *levels = [partyMember elementsForName:@"Level"];
        if([levels count] > 0)
        {
            GDataXMLElement *firstLevel = (GDataXMLElement *)[levels objectAtIndex:0];
            level = [[firstLevel stringValue] intValue];
        } else {
            continue;
        }
        
        // Class
        NSArray *classes = [partyMember elementsForName:@"Class"];
        if([classes count] > 0)
        {
            GDataXMLElement *firstClass = (GDataXMLElement *)[classes objectAtIndex:0];
            if([[firstClass stringValue] caseInsensitiveCompare:@"Fighter"] == NSOrderedSame)
            {
                rpgClass = RPGClassFighter;
            } else if ([[firstClass stringValue] caseInsensitiveCompare:@"Rogue"] == NSOrderedSame)
            {
                rpgClass = RPGClassRogue;
            } else if ([[firstClass stringValue] caseInsensitiveCompare:@"Wizard"] == NSOrderedSame)
            {
                rpgClass = RPGClassWizard;
            } else {
                continue;
            }
        } else {
            continue;
        }
        
        BFPlayer *player = [[BFPlayer alloc] initWithName:name level:level rpgClass:rpgClass];
        [party.players addObject:player];
    }
    return party;
}

@end
