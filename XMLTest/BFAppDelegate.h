//
//  BFAppDelegate.h
//  XMLTest
//
//  Created by Wang Long on 1/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFParty;
@class BFViewController;

@interface BFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BFViewController *viewController;
@property (strong, nonatomic) BFParty *party;

@end
