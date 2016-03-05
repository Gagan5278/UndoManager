//
//  AppDelegate.h
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DraggableView.h"

@protocol SelectedView
-(void)currentTouchView:(DraggableView*)view;
//-(void)currentCenterOfView:(DraggableView*)view;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//
@property(nonatomic,strong)NSMutableArray *arrayOfRecord;
//
@property(nonatomic,weak) id <SelectedView> touchViewDelegate;
//
@property(nonatomic,strong)NSMutableDictionary *dictionaryOfRecord;

+(AppDelegate*)objectAppDelegate;

@end

