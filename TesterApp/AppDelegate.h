//
//  AppDelegate.h
//  TesterApp
//
//  Created by Ogishi on 7/24/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


    // TODO: make it a "private" function..
    - (void)setupNavControllerVisuals: (UINavigationController *)navController;


    @property (strong, nonatomic) UIWindow *window;
    @property (strong, nonatomic) ViewController *viewController;
    @property (strong, nonatomic) UINavigationController *navController;

@end
