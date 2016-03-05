//
//  JSONParser.h
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject


+ (id) sharedParserManager;

-(NSMutableArray*)getAllObjectsFromFile;
-(NSString*)getJSONStringFromArray;
-(void)saveInDocumentDirectory;

@end
