//
//  DataBaseManager.h
//  WeiboTest
//
//  Created by lucas on 5/9/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "WeiboStatus.h"

@interface DatabaseManager : NSObject

@property (nonatomic, retain) FMDatabase *database;

- (BOOL)databaseInsert:(WeiboStatus *)status;
- (NSMutableArray *)databaseAllStatuses;
- (NSString *)databaseGetId:(BOOL)max;
- (BOOL)databaseDropTable;
- (void)databaseClose;
@end
