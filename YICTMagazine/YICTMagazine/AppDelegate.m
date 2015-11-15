//
//  AppDelegate.m
//  YICTMagazine
//
//  Created by Seven on 13-8-15.
//  Copyright (c) 2013年 YICT. All rights reserved.
//

#import "AppDelegate.h"
#import "ReceiveDevice.h"
#import "AppSettingKeys.h"
#import "WebApiAccessConfig.h"
#import "NewsDetailsViewController.h"
#import "MagazineTabBarViewController.h"
#import "Magazine.h"
#import "AccessStatistic.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/SDWebImagePrefetcher.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize window, rootViewController;
@synthesize hostReachability, internetReachability, wifiReachability, hadTipUnusedWifi;
@synthesize deviceTokenString;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Network reachability
    //监听网络状态改变的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    //监听网络改变状况。
     hostReachability = [Reachability reachabilityWithHostName:kWebApiAccessDomainName];
    
    //启动监听方法
	[hostReachability startNotifier];
	
    //监听网络连接状况。
    internetReachability = [Reachability reachabilityForInternetConnection];
	[internetReachability startNotifier];
    
    //监听是不是有可用的WiFi
    wifiReachability = [Reachability reachabilityForLocalWiFi];
	[wifiReachability startNotifier];
    hadTipUnusedWifi = NO;
    
    

    // Override point for customization after application launch
    //保存数据。
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[NSMutableArray alloc] init], kNewsCategoryType,
                              [NSNumber numberWithBool:YES], kEnabledNotification,
                              [NSNumber numberWithBool:YES], kEnabledAutomaticDownload, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    
    
    
    // Let the device know we want to receive push notifications
//    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    //注册消息来的提示方式，有三种UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert分别为震动，声音，和提示。
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    
    
    // Setting badge
    /*
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil)
    {
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge > 0)
        {
            badge--;
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }
    */
    //程序启动是检查是否有UILocalNotification，如果有跳出提示框
    application.applicationIconBadgeNumber = 0;
    
    
    
    // Access statistic
    [AccessStatistic send];
    

    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootViewController *rootVC = [[RootViewController alloc]init];
    window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    

    
    
    // Background download
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL enabledAutomaticDownload = [userDefaults boolForKey:kEnabledAutomaticDownload];
    if (internetReachability.currentReachabilityStatus != NotReachable
        && wifiReachability.currentReachabilityStatus != NotReachable
        && enabledAutomaticDownload == YES)
    {
        [self performSelectorInBackground:@selector(downloadMagazines) withObject:nil];
    }


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *_deviceTokenString = [deviceToken description];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    _deviceTokenString = [_deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceTokenString = _deviceTokenString;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (internetReachability.currentReachabilityStatus != NotReachable)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isSubscribe = [userDefaults boolForKey:kEnabledNotification];
            ReceiveDevice *receiveDevice = [[ReceiveDevice alloc] initWithAttributes:_deviceTokenString
                                                                         isSubscribe:isSubscribe];
            [receiveDevice syncDeviceToken];
        });
        
        // Sync news category
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *newsCategoryIdArray = [userDefaults objectForKey:kNewsCategoryType];
            if ([newsCategoryIdArray count] > 0)
            {
                ReceiveDevice *receiveDevice = [[ReceiveDevice alloc] init];
                receiveDevice.deviceTokenString = self.deviceTokenString;
                [receiveDevice syncNotificationNewsCategoryList:newsCategoryIdArray];
            }
        });
         */
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSDictionary *alert = [aps objectForKey:@"alert"];
    NSString *body = [alert objectForKey:@"body"];
    body = [body stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil)
    {
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *currentId = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
        RootViewController *rootVC = (RootViewController*)window.rootViewController;
        rootVC.welcomeVC.view.hidden = YES;

        if ([type isEqualToString:@"news"])
        {
            NewsDetailsViewController *controller = [[NewsDetailsViewController alloc] init];
            controller.dataObject = currentId;
            [rootVC.homeVC.navigationController pushViewController:controller animated:YES];
        }
        else if ([type isEqualToString:@"magazine"])
        {
            MagazineTabBarViewController *controller = [[MagazineTabBarViewController alloc] initWithDataObject:currentId];
            [rootVC.homeVC.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YICTMagazine" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YICTMagazine.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)reachabilityChanged:(NSNotification*)note
{
    
}

// Download magazine
- (void)downloadMagazines
{
    sleep(30);
    [[SDWebImagePrefetcher sharedImagePrefetcher] setMaxConcurrentDownloads:1];
    
    Result *result = [Magazine getList:NO isNew:YES offset:0 limit:0];
    if (result.isSuccess && result.data != nil)
    {
        NSArray *magazineArray = result.data;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (Magazine *magazine in magazineArray)
        {
            if (magazine.hasDownloaded == NO)
            {
                Result *magazineResult = [Magazine getDetail:magazine.magazineId];
                if (magazineResult.isSuccess && magazineResult.data != nil)
                {
                    Magazine *currentMagazine = magazineResult.data;
                    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                    if (currentMagazine.coverImageUrlString != nil)
                    {
                        [imageArray addObject:currentMagazine.coverImageUrlString];
                    }
                    for (MagazineImage *magazineImage in currentMagazine.images)
                    {
                        if (magazineImage.thumbImageUrlString != nil)
                        {
                            [imageArray addObject:magazineImage.thumbImageUrlString];
                        }
                        if (magazineImage.origImageUrlString != nil)
                        {
                            [imageArray addObject:magazineImage.origImageUrlString];
                        }
                    }
                    
                    if ([imageArray count] > 0)
                    {
                        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageArray completed:^(NSUInteger finishedCount, NSUInteger skippedCount) {
                            dispatch_semaphore_signal(semaphore);
                        }];
                    }
                    else
                    {
                        dispatch_semaphore_signal(semaphore);
                    }
                    
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    [currentMagazine refreshDownloadStatus];
                    currentMagazine = nil;
                }
            }
        }
    }
}

@end
