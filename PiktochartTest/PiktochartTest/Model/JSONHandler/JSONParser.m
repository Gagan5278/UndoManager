//
//  JSONParser.m
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import "JSONParser.h"

#define fileName @"JSONFile.json"

@implementation JSONParser

+ (id) sharedParserManager {
    static dispatch_once_t  dispathcOnce;
    static JSONParser *sharedObject = nil;
    dispatch_once(&dispathcOnce, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(NSMutableArray*)getAllObjectsFromFile
{
    NSURL *jsonFileURL = nil; //[[NSUserDefaults standardUserDefaults]boolForKey:isAppInstalledAndRun]?
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:[[AppDelegate objectAppDelegate].applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:fileName]].path])
    {
        jsonFileURL =[[AppDelegate objectAppDelegate].applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:fileName]];
    }
    else{
        jsonFileURL = [[NSBundle mainBundle]URLForResource:@"JSONFile" withExtension:@"json"];
    }

    // NSURL *jsonFileURL =[[NSBundle mainBundle]URLForResource:@"JSONFile" withExtension:@"json"];
    if (jsonFileURL.fileURL)
    {
        NSData *contentData = [NSData dataWithContentsOfURL:jsonFileURL];
        id record= [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
        if([record isKindOfClass:[NSArray class]])
        {
            return record;
        }
    }
    return nil;
}

-(void)saveInDocumentDirectory
{
    NSURL *filePathURL= [[AppDelegate objectAppDelegate].applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:fileName]];
    NSError *error=nil;
    if([[self getJSONStringFromArray] writeToURL:filePathURL atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"File saved at path: %@",filePathURL);
        UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"Message" message:@"File saved successfully. Please find path in log." preferredStyle:UIAlertControllerStyleAlert];
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UINavigationController *mainController = (UINavigationController*)[keyWindow rootViewController];
        UIViewController *controller =[mainController.viewControllers lastObject];
        UIAlertAction *alertAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSLog(@"error is : %@",error.localizedDescription);
    }
}

-(NSString*)getJSONStringFromArray
{
    NSError* error = nil;
    NSData *dataFromArray = [NSJSONSerialization dataWithJSONObject:[AppDelegate objectAppDelegate].arrayOfRecord options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:dataFromArray encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
