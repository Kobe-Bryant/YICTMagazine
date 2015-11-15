//
//  AppDelegate.h
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "RootViewController.h"
#import "WelcomeViewController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) Reachability* hostReachability;
@property (strong, nonatomic) Reachability* internetReachability;
@property (strong, nonatomic) Reachability* wifiReachability;
@property (readwrite, nonatomic) BOOL hadTipUnusedWifi;
@property (strong, nonatomic) NSString *deviceTokenString;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
