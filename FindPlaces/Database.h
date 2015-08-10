/********************************************************************************\
 *
 * File Name       Database.h
 * Author          $Author:: Pooja Jalan  $: Author of last commit
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2011-12-15 16:01:19#$: Date of last commit
 * 
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : NSObject {

	sqlite3 *databaseObj;

}
+(Database*) shareDatabase;
+(Database*) sharedDatabase;
+(Database*) newDatabase;
-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;

-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(NSMutableArray *)SelectAllFromTableWithLog:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
- (void)Insert:(NSString *)query;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;
-(void)UpdateWithPower:(NSString *)query;

- (NSMutableArray *)getAllDataForQuery:(NSString *)sql;
-(NSInteger) getMaxValueForQuery:(NSString *)sql;
- (NSMutableArray *)fetchParticularData:(NSString *)query;
-(NSInteger) getSumOfValueForQuery:(NSString *)sql;

-(NSString *) getFirstValueForQuery:(NSString *)sql;
-(NSMutableArray *) getFirstColumnForQuery:(NSString *)sql;
-(NSMutableDictionary *) getFirstRowForQuery:(NSString *)sql;
-(NSString*) getSingleDataValueForQuery:(NSString *)sql;
-(NSInteger) getMaxValueFromTable:(NSString *)strTableName forField:(NSString *)strFieldName;

//Jatin Patel
-(void)UpdateForBackGround:(NSString *)query;
-(NSString*) getSingleDataValueForQueryForBackGround:(NSString *)sql;
- (void)InsertForBackGround:(NSString *)query; 
-(NSMutableArray *)SelectAllFromTableForBackGround:(NSString *)query;
-(void)DeleteForBackGround:(NSString *)query;
-(NSString *) getFirstValueForQueryForBackGround:(NSString *)sql;
-(NSMutableDictionary *) getFirstRowForQueryForBackGround:(NSString *)sql;
//End

///Shail
- (void)insertMultipleRecordsWithDictionary:(NSMutableDictionary *)dictParameter inTable:(NSString *)tableName;
- (void)insertMultipleRecordsWithArray:(NSMutableArray *)arrayParameter inTable:(NSString *)tableName;

///

@end
