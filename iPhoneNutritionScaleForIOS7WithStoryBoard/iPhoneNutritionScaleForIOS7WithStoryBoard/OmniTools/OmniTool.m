//
//  OmniTool.m
//  KitchenScale
//
//  Created by Orange on 13/4/3.
//  Copyright (c) 2013年 Orange. All rights reserved.
//

#import "OmniTool.h"
#import "AppDelegate.h"
//#import "viewmain.h"
#import "UIImage+ResizeAdditions.h" //照片工具
#import "Food.h"
#import "FoodNutrient.h"
#import "sys/utsname.h"

@implementation OmniTool

+ (int) adjustUnit:(int) unit
{
	  switch(unit)
	{
	      case UNIT_LB:
	      case UNIT_G:
	      case UNIT_OZ:
	      case UNIT_CATTY:
	      case UNIT_TAEL:
	      case UNIT_CHIAN:
	      	return unit;
	          break;
	      default:
	      	return UNIT_G;
	}
}
+(int) unitStringToInt:(NSString*) unitString
{
	if([unitString isEqualToString:@"g"])
		return UNIT_G;
	if([unitString isEqualToString:@"lb"])
		return UNIT_LB;
	if([unitString isEqualToString:@"oz"])
		return UNIT_OZ;
	if([unitString isEqualToString:@"斤"])
		return UNIT_CATTY;
	if([unitString isEqualToString:@"兩"])
		return UNIT_TAEL;
	if([unitString isEqualToString:@"錢"])
		return UNIT_CHIAN;
	return UNIT_G;
}
+(NSString*) unitIntToString:(int) unitInt
{
	  switch(unitInt)
	{
	      case UNIT_LB:
	      	return @"lb";
	      case UNIT_G:
	      	return @"g";
	      case UNIT_OZ:
	      	return @"oz";
	      case UNIT_CATTY:
	      	return @"斤";
	      case UNIT_TAEL:
	      	return @"兩";
	      case UNIT_CHIAN:
	      	return @"錢";
	      default:
	      	return @"g";
	}
}

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"] || [deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

/*
+ (void)s_cmdObjects:(char *)sender{
	  viewMain *viewVC = [viewMain alloc];
	  NSLog(@"viewMain alloc");
	  NSString *cha = [NSString stringWithFormat:@"%s",sender];
	  [viewVC setDetailItem:cha];
}
*/
// time to HH:MM:SS
+(NSString*) timerToString:(CFAbsoluteTime) t
{
	t=t+0.9; // 最後一秒應該顯示1而不是0
	int sec= ((int)t) % 60;
	int min=((int)t/60) % 60;
	int hr=((int)t/3600) % 25;
	return [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",hr,min,sec] ;  
}

/*
#pragma mark Facebook
+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
	  if (newProfilePictureData.length == 0) {
	      NSLog(@"Profile picture did not download successfully.");
	      return;
	  }
	  
	  // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.
	  
	  NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
	  
	  NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
	  
	  if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
	      // We have a cached Facebook profile picture
	      
	      NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
	      
	      if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
	          NSLog(@"Cached profile picture matches incoming profile picture. Will not update.");
	          return;
	      }
	  }
	  
	  BOOL cachedToDisk = [[NSFileManager defaultManager] createFileAtPath:[profilePictureCacheURL path] contents:newProfilePictureData attributes:nil];
	  NSLog(@"Wrote profile picture to disk cache: %d", cachedToDisk);
	  
	  UIImage *image = [UIImage imageWithData:newProfilePictureData];
	  
	  UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	  UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
	  
	  NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
	  NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
	  
	  if (mediumImageData.length > 0) {
	      NSLog(@"Uploading Medium Profile Picture");
	      PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
	      [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	          if (!error) {
	              NSLog(@"Uploaded Medium Profile Picture");
	              [[PFUser currentUser] setObject:fileMediumImage forKey:kPAPUserProfilePicMediumKey];
	              [[PFUser currentUser] saveEventually];
	          }
	      }];
	  }
	  
	  if (smallRoundedImageData.length > 0) {
	      NSLog(@"Uploading Profile Picture Thumbnail");
	      PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
	      [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	          if (!error) {
	              NSLog(@"Uploaded Profile Picture Thumbnail");
	              [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kPAPUserProfilePicSmallKey];
	              [[PFUser currentUser] saveEventually];
	          }
	      }];
	  }
}


//用戶有一個有效的Facebook數據
+ (BOOL)userHasValidFacebookData:(PFUser *)user {
	  NSString *facebookId = [user objectForKey:kPAPUserFacebookIDKey];
	  return (facebookId && facebookId.length > 0);
}
//用戶是否有的照片
+ (BOOL)userHasProfilePictures:(PFUser *)user {
	  PFFile *profilePictureMedium = [user objectForKey:kPAPUserProfilePicMediumKey];
	  PFFile *profilePictureSmall = [user objectForKey:kPAPUserProfilePicSmallKey];
	  
	  return (profilePictureMedium && profilePictureSmall);
}

//截取用戶的名字顯示在DisplayName上
+ (NSString *)firstNameForDisplayName:(NSString *)displayName{
	  if (!displayName || displayName.length == 0) {
	      return @"Someone";
	  }
	  
	  NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	  NSString *firstName = [displayNameComponents objectAtIndex:0];
	  if (firstName.length > 100) {
	      // truncate to 100 so that it fits in a Push payload
	      firstName = [firstName substringToIndex:100];
	  }
	  return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	  if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
	      return;
	  }
	  
	  PFObject *followActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
	  [followActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
	  [followActivity setObject:user forKey:kPAPActivityToUserKey];
	  [followActivity setObject:[NSNumber numberWithInt:kPAPActivityTypeFollow] forKey:kPAPActivityTypeKey];
	  
	  PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
	  [followACL setPublicReadAccess:YES];
	  followActivity.ACL = followACL;
	  
	  [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	      if (completionBlock) {
	          completionBlock(succeeded, error);
	      }
	      
	      if (succeeded) {
	          //            [PAPUtility sendFollowingPushNotification:user];  移除好友安裝wheels的推播。
	      }
	  }];
	  [[OmniCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	  if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
	      return;
	  }
	  
	  PFObject *followActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
	  [followActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
	  [followActivity setObject:user forKey:kPAPActivityToUserKey];
	  [followActivity setObject:[NSNumber numberWithInt:kPAPActivityTypeFollow] forKey:kPAPActivityTypeKey];
	  
	  PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
	  [followACL setPublicReadAccess:YES];
	  followActivity.ACL = followACL;
	  
	  [followActivity saveEventually:completionBlock];
	  [[OmniCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	  for (PFUser *user in users) {
	      [OmniTool followUserEventually:user block:completionBlock];
	      [[OmniCache sharedCache] setFollowStatus:YES user:user];
	  }
}

+ (void)unfollowUserEventually:(PFUser *)user {
	  PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
	  [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
	  [query whereKey:kPAPActivityToUserKey equalTo:user];
	  [query whereKey:kPAPActivityTypeKey equalTo:[NSNumber numberWithInt:kPAPActivityTypeFollow]];
	  [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
	      // While normally there should only be one follow activity returned, we can't guarantee that.
	      
	      if (!error) {
	          for (PFObject *followActivity in followActivities) {
	              [followActivity deleteEventually];
	          }
	      }
	  }];
	  [[OmniCache sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users {
	  PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
	  [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
	  [query whereKey:kPAPActivityToUserKey containedIn:users];
	  [query whereKey:kPAPActivityTypeKey equalTo:[NSNumber numberWithInt:kPAPActivityTypeFollow]];
	  [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
	      for (PFObject *activity in activities) {
	          [activity deleteEventually];
	      }
	  }];
	  for (PFUser *user in users) {
	      [[OmniCache sharedCache] setFollowStatus:NO user:user];
	  }
}

#pragma mark Push
+ (void)sendFollowingPushNotification:(PFUser *)user {
	  NSString *privateChannelName = [user objectForKey:kPAPUserPrivateChannelKey];
	  if (privateChannelName && privateChannelName.length != 0) {
	      NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
	                            [NSString stringWithFormat:NSLocalizedStringFromTable( @"notifyFriendInstall", @"InfoPlist" , @"推播訊息" ), [OmniTool firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]]], kAPNSAlertKey,
	                            kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
	                            kPAPPushPayloadActivityFollowKey, kPAPPushPayloadActivityTypeKey,
	                            [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
	                            nil];
	      PFPush *push = [[PFPush alloc] init];
	      [push setChannel:privateChannelName];
	      [push setData:data];
	      [push sendPushInBackground];
	  }
}
 
 */

+(NSMutableArray *)searchFood:(NSString *) keyword
{
	return [OmniTool searchFood:keyword RecordCount:50];
}
+(NSMutableArray *)searchFood:(NSString *) keyword RecordCount:(int)recordCount;	
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *likeParameter = [NSString stringWithFormat:@"%@%%", keyword];
	NSString *likeParameter2 = [NSString stringWithFormat:@"%%%@%%", keyword];
	if(recordCount<=0)
		recordCount=50;
		
	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return nil;
	}
	
	// those who started with keyword
//	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount];
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no,food_des.long_desc,food_des.shrt_desc,fd_group.fdgrp_desc,fd_group.fdgrp_cd FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount];
	FMResultSet *rs=[db executeQuery:sql,likeParameter];
	if (!rs)
	{
	    NSLog(@"error1: %@", [db lastErrorMessage]);
	      
	    [db close];
	    return array;
	}

	while([rs next]){
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
//		[f setFactorCarbohydrate:[rs doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs doubleForColumn:@"n_factor"]];
		[OmniTool seperateTitleSubtitle:f];
		[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
		[dic setObject:f forKey:[f foodNumber]];
		[array addObject:f];
	}

	// those who contains keyword
//	NSString *sql2=[NSString stringWithFormat:@"SELECT * FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount];
	NSString *sql2=[NSString stringWithFormat:@"SELECT food_des.ndb_no,food_des.long_desc,food_des.shrt_desc,fd_group.fdgrp_desc,fd_group.fdgrp_cd FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount];
	FMResultSet *rs2=[db executeQuery:sql2,likeParameter2];
	if (!rs2)
	{
	    NSLog(@"error2: %@", [db lastErrorMessage]);
	    [db close];
	    return array;
	}
	while([rs2 next]){
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs2 intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs2 stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs2 stringForColumn:@"shrt_desc"]];
		[f setFoodGroup:[rs2 stringForColumn:@"fdgrp_desc"]];
//		[f setFactorCarbohydrate:[rs2 doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs2 doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs2 doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs2 doubleForColumn:@"n_factor"]];
		
		// check if it's already in dic
		if([dic objectForKey:[f foodNumber]]==nil){
			// if not, add into array
			[dic setObject:f forKey:[f foodNumber]];
			[OmniTool seperateTitleSubtitle:f];
			[f setFoodImageWithGroupID:[rs2 intForColumn:@"fdgrp_cd"]];
			[array addObject:f];
		}
	}

	[db close];
	  return array;
}

+(NSMutableArray *)getFoodNutrient:(NSNumber *)foodNumber
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];

	if(foodNumber==nil){
		NSLog(@"getFoodNutrient: foodNumber is nil!!");
		return array;
	}
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}

	// those who started with foodNumber
	/*
	SELECT * FROM nut_data,nutr_def,nutr_group
	WHERE nut_data.nutr_no=nutr_def.nutr_no 
	AND nutr_def.nutr_no=nutr_group.nutr_no
	AND nut_data.ndb_no='%@' 
	ORDER BY nutr_def.sr_order;
	*/
//	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM nut_data,nutr_def,nutr_group WHERE nut_data.nutr_no=nutr_def.nutr_no  AND nutr_def.nutr_no=nutr_group.nutr_no AND nut_data.ndb_no=%@  ORDER BY nutr_def.sr_order; ",foodNumber];
	NSString *sql=[NSString stringWithFormat:@"SELECT nut_data.ndb_no ,nut_data.nutr_no ,nutr_def.nutrdesc ,nut_data.nutr_val ,nutr_def.units ,nutr_def.sr_order ,nutr_group.nutr_groupname ,nutr_group.nutr_shortname FROM nut_data,nutr_def,nutr_group  WHERE nut_data.nutr_no=nutr_def.nutr_no  AND nutr_def.nutr_no=nutr_group.nutr_no AND nut_data.ndb_no=%@  ORDER BY nutr_def.sr_order; ",foodNumber]; 
	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		FoodNutrient *f=[FoodNutrient alloc];

		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setNutrientNumberWithInt:[rs intForColumn:@"nutr_no"]];
		[f setNutrientName:[rs stringForColumn:@"nutrdesc"]];
//		[f setTagName:[rs stringForColumn:@"tagname"]];
		[f setNutrientValue:[rs doubleForColumn:@"nutr_val"]];
		[f setUnit:[rs stringForColumn:@"units"]];
			
//		[f setDataPoint:[rs intForColumn:@"num_data_pts"]];
//		[f setStdError:[rs doubleForColumn:@"std_error"]];
		[f setSearchOrder:[rs intForColumn:@"sr_order"]];
		[f setNutrientType:[rs stringForColumn:@"nutr_groupname"]];
		[f setNutrientShortName:[rs stringForColumn:@"nutr_shortname"]];
		[array addObject:f];
	}
	[db close];



	  return array;	
}
+(NSMutableArray *)getFoodNutrientOnlyInRDA:(NSNumber *)foodNumber
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];

	if(foodNumber==nil){
		NSLog(@"getFoodNutrientOnlyInRDA: foodNumber is nil!!");
		return array;
	}
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}

	// those who started with foodNumber
	/*	
		SELECT nut_data.ndb_no ,nut_data.nutr_no ,nutr_def.nutrdesc ,nut_data.nutr_val ,nutr_def.units ,nutr_def.sr_order ,nutr_group.nutr_groupname ,nutr_group.nutr_shortname
		FROM nut_data,nutr_def,nutr_group,dri
		WHERE nut_data.nutr_no=nutr_def.nutr_no 
		AND nutr_def.nutr_no=nutr_group.nutr_no
		AND nut_data.ndb_no='1002'
		AND nut_data.nutr_no=dri.nutr_no
		AND dri.dri_user=1
		ORDER BY nutr_def.sr_order;
	*/
	NSString *sql=[NSString stringWithFormat:@"SELECT nut_data.ndb_no,nut_data.nutr_no,nutr_def.nutrdesc,nut_data.nutr_val,nutr_def.units,nutr_def.sr_order,nutr_group.nutr_groupname,nutr_group.nutr_shortname FROM nut_data,nutr_def,nutr_group,dri WHERE nut_data.nutr_no=nutr_def.nutr_no  AND nutr_def.nutr_no=nutr_group.nutr_no AND nut_data.ndb_no='%d' AND nut_data.nutr_no=dri.nutr_no AND dri.dri_user=1 ORDER BY nutr_def.sr_order; ",[foodNumber intValue]]; 
	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		FoodNutrient *f=[FoodNutrient alloc];

		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setNutrientNumberWithInt:[rs intForColumn:@"nutr_no"]];
		[f setNutrientName:[rs stringForColumn:@"nutrdesc"]];
//		[f setTagName:[rs stringForColumn:@"tagname"]];
		[f setNutrientValue:[rs doubleForColumn:@"nutr_val"]];
		[f setUnit:[rs stringForColumn:@"units"]];
			
//		[f setDataPoint:[rs intForColumn:@"num_data_pts"]];
//		[f setStdError:[rs doubleForColumn:@"std_error"]];
		[f setSearchOrder:[rs intForColumn:@"sr_order"]];
		[f setNutrientType:[rs stringForColumn:@"nutr_groupname"]];
		[f setNutrientShortName:[rs stringForColumn:@"nutr_shortname"]];
		[array addObject:f];
	}
	[db close];

	return array;	
}
+(void)logSearch:(NSNumber *)foodNumber
{
//	NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"usda" ofType:@"db"];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return;
	}
	
	NSString *updateSql = [NSString stringWithFormat:@"INSERT INTO food_search_log(ndb_no,search_time) VALUES(%@,%f)", foodNumber, CFAbsoluteTimeGetCurrent()];
	[db executeUpdate:updateSql];
	
	[db close];
}

+(void)testTable:(NSString *)tableName
{
	NSLog(@"=============== Checking table: %@ ===================",tableName);

//	NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"usda" ofType:@"db"];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return;
	}
	
	FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"SELECT * from %@",tableName]];
	while([rs next]){
	 		NSString *col1=[rs stringForColumnIndex:0];
	 		NSString *col2=[rs stringForColumnIndex:1];
	 		NSString *col3=[rs stringForColumnIndex:2];
	 		NSString *col4=[rs stringForColumnIndex:3];
	        NSLog(@"Record: %@ ,%@ ,%@ ,%@"
	        	,col1
	        	,col2
	        	,col3
	        	,col4
	        		);
	}
	[db close];
}

+(void)initialDatabase:(NSString *)dbFilename
{
	// Get the path to the main bundle resource directory.
	NSString *pathsToResources = [[NSBundle mainBundle] resourcePath];
	NSString *yourOriginalDatabasePath = [pathsToResources stringByAppendingPathComponent:dbFilename];
	// Create the path to the database in the Documents directory.
	NSString *yourNewDatabasePath = [OmniTool getDatabasePath:dbFilename];
	
	if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
		if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
			NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
	
	}
}

+(NSString *)getDatabasePath:(NSString *)dbFileName
{
	NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
	
	return [documentsDirectory stringByAppendingPathComponent:dbFileName];
}
+(void)updateSearchCount:(NSNumber *)foodNumber
{
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
	}

	int searchCount=[OmniTool getSearchCount:foodNumber];
	if(searchCount<=0){
		NSString *updateSql = [NSString stringWithFormat:@"INSERT INTO food_search_count(ndb_no,sr_count) VALUES('%@',1)", foodNumber];
	    [db executeUpdate:updateSql];
	}else{
		NSString *updateSql = [NSString stringWithFormat:@"UPDATE food_search_count SET sr_count=%d WHERE ndb_no='%@'",searchCount+1, foodNumber];
	    [db executeUpdate:updateSql];
	}
	[db close];
}

+(int)getSearchCount:(NSNumber *)foodNumber
{

	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	int searchCount=-1;
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
	}
	
	FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"SELECT sr_count from food_search_count where ndb_no='%@'",foodNumber]];
	while([rs next]){
		searchCount=[rs intForColumn:@"sr_count"];
	}
	[db close];
	return searchCount;
}
+(NSMutableArray *)recentSearch
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return nil;
	}
	/*
	SELECT * 
	FROM food_des,food_search_log,fd_group
	WHERE food_search_log.ndb_no=food_des.ndb_no 
	AND food_des.fdgrp_cd=fd_group.fdgrp_cd
	ORDER BY food_search_log.search_time DESC
	*/
//	NSString *sql=[NSString stringWithFormat:@"SELECT *  FROM food_des,food_search_log,fd_group WHERE food_search_log.ndb_no=food_des.ndb_no  AND food_des.fdgrp_cd=fd_group.fdgrp_cd ORDER BY food_search_log.search_time DESC LIMIT 0,5"];
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no, food_des.long_desc, food_des.shrt_desc, fd_group.fdgrp_desc, fd_group.fdgrp_cd FROM food_des,food_search_log,fd_group  WHERE food_search_log.ndb_no=food_des.ndb_no  AND food_des.fdgrp_cd=fd_group.fdgrp_cd ORDER BY food_search_log.search_time DESC LIMIT 0,5"]; 
	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
//		[f setFactorCarbohydrate:[rs doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs doubleForColumn:@"n_factor"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
		// check if it's already in dic
		if([dic objectForKey:[f foodNumber]]==nil){
			// if not, add into array
			[dic setObject:f forKey:[f foodNumber]];
			[OmniTool seperateTitleSubtitle:f];
			[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
			[array addObject:f];
		}
	}

	[db close];
	  return array;
}
+(NSMutableArray *)mostSearch
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return nil;
	}
	/*
	SELECT * 
	FROM food_des,food_search_count,fd_group
	WHERE food_search_count.ndb_no=food_des.ndb_no 
	AND food_des.fdgrp_cd=fd_group.fdgrp_cd
	ORDER BY food_search_count.sr_count DESC
	*/
//	NSString *sql=[NSString stringWithFormat:@"SELECT *  FROM food_des,food_search_count,fd_group WHERE food_search_count.ndb_no=food_des.ndb_no  AND food_des.fdgrp_cd=fd_group.fdgrp_cd ORDER BY food_search_count.sr_count DESC LIMIT 0,5"];
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no, food_des.long_desc, food_des.shrt_desc, fd_group.fdgrp_desc, fd_group.fdgrp_cd,food_search_count.sr_count FROM food_des,food_search_count,fd_group WHERE food_search_count.ndb_no=food_des.ndb_no  AND food_des.fdgrp_cd=fd_group.fdgrp_cd ORDER BY food_search_count.sr_count DESC LIMIT 0,5"];

	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
//		[f setFactorCarbohydrate:[rs doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs doubleForColumn:@"n_factor"]];
		[f setSearchCount:[rs intForColumn:@"sr_count"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
		[OmniTool seperateTitleSubtitle:f];
		[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
		[array addObject:f];
	}

	[db close];
	  return array;
}
+(NSMutableArray *)getRDAList:(int) userType
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}

	/*
		SELECT *
		FROM dri,nutr_def,nutr_group
		WHERE dri.nutr_no=nutr_def.nutr_no 
		AND dri.nutr_no=nutr_group.nutr_no
		AND dri.dri_user=%d 
		AND dri.dri_rda>0 
		ORDER BY nutr_def.sr_order;
	*/
//	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM dri,nutr_def,nutr_group WHERE dri.nutr_no=nutr_def.nutr_no  AND dri.nutr_no=nutr_group.nutr_no AND dri.dri_user=%d  AND dri.dri_rda>0  ORDER BY nutr_def.sr_order;",userType];
	NSString *sql=[NSString stringWithFormat:@"SELECT dri.nutr_no, nutr_def.nutrdesc, dri.dri_rda, nutr_def.units, nutr_def.sr_order, nutr_group.nutr_groupname, nutr_group.nutr_shortname FROM dri,nutr_def,nutr_group WHERE dri.nutr_no=nutr_def.nutr_no AND dri.nutr_no=nutr_group.nutr_no AND dri.dri_user=%d AND dri.dri_rda>0 ORDER BY nutr_def.sr_order;",userType]; 
	FMResultSet *rs=[db executeQuery:sql];

	while([rs next]){
		FoodNutrient *f=[FoodNutrient alloc];

		[f setNutrientNumberWithInt:[rs intForColumn:@"nutr_no"]];
		[f setNutrientName:[rs stringForColumn:@"nutrdesc"]];
		// [f setTagName:[rs stringForColumn:@"tagname"]];
		[f setNutrientValue:[rs doubleForColumn:@"dri_rda"]];
		[f setUnit:[rs stringForColumn:@"units"]];
		[f setSearchOrder:[rs intForColumn:@"sr_order"]];
		[f setNutrientType:[rs stringForColumn:@"nutr_groupname"]];
		[f setNutrientShortName:[rs stringForColumn:@"nutr_shortname"]];
		[array addObject:f];
	}
	[db close];
	return array;	
}
+(NSMutableArray *)getRDAList:(int) userType withNutrientType:(NSString *)nutrientType
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}
	/*
		SELECT *
		FROM dri,nutr_def,nutr_group
		WHERE dri.nutr_no=nutr_def.nutr_no 
		AND dri.nutr_no=nutr_group.nutr_no
		AND nutr_group.nutr_groupname='%@'
		AND dri.dri_user=%d 
		AND dri.dri_rda>0 
		ORDER BY nutr_def.sr_order;
	*/
//	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM dri,nutr_def,nutr_group WHERE dri.nutr_no=nutr_def.nutr_no  AND dri.nutr_no=nutr_group.nutr_no AND nutr_group.nutr_groupname='%@' AND dri.dri_user=%d  AND dri.dri_rda>0  ORDER BY nutr_def.sr_order;",nutrientType,userType];
	NSString *sql=[NSString stringWithFormat:@"SELECT dri.nutr_no, nutr_def.nutrdesc, dri.dri_rda, nutr_def.units, nutr_def.sr_order, nutr_group.nutr_groupname, nutr_group.nutr_shortname FROM dri,nutr_def,nutr_group WHERE dri.nutr_no=nutr_def.nutr_no  AND dri.nutr_no=nutr_group.nutr_no AND nutr_group.nutr_groupname='%@' AND dri.dri_user=%d  AND dri.dri_rda>0  ORDER BY nutr_def.sr_order;",nutrientType,userType];

	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		FoodNutrient *f=[FoodNutrient alloc];

		[f setNutrientNumberWithInt:[rs intForColumn:@"nutr_no"]];
		[f setNutrientName:[rs stringForColumn:@"nutrdesc"]];
//		[f setTagName:[rs stringForColumn:@"tagname"]];
		[f setNutrientValue:[rs doubleForColumn:@"dri_rda"]];
		[f setUnit:[rs stringForColumn:@"units"]];
		[f setSearchOrder:[rs intForColumn:@"sr_order"]];
		[f setNutrientType:[rs stringForColumn:@"nutr_groupname"]];
		[f setNutrientShortName:[rs stringForColumn:@"nutr_shortname"]];
		[array addObject:f];
	}
	[db close];
	
	  return array;	
}
+(NSMutableArray *)getFoodRDAWithInt:(int)foodNumber forUserType:(int) userType weight:(double)gram
{
	return [OmniTool getFoodRDA:[[NSNumber alloc] initWithInt:foodNumber] forUserType:userType weight:gram];
}

/* a cache for getFoodRDA
 NSMutableDictionary(foodNumber->NSMutableDictionary(NSNumber:userType->NSMutableArray))
 saved percentage and value are only for 100g food

 NSMutableDictionary *foodRDAdictionary
 
 	(userType -> rdaTypeDictionary)
 	
 NSMutableDictionary *rdaTypeDictionary 	
 	(foodNumber->foodRDAList)
 
 NSMutableArray *foodRDAList;
 	array of FoodNutrient
 
*/
+(NSMutableArray *)getFoodRDAcache:(NSNumber *)foodNumber forUserType:(int) userType
{
	NSNumber *userTypeNumber = [[NSNumber alloc] initWithInt:userType];
		
	if(!foodRDAdictionary){
		foodRDAdictionary= [[NSMutableDictionary alloc]init];
		return nil;
	}
	NSMutableDictionary *rdaTypeDictionary=[foodRDAdictionary objectForKey:foodNumber];
	if(!rdaTypeDictionary)
	{
		rdaTypeDictionary= [[NSMutableDictionary alloc]init];
		[foodRDAdictionary setObject:rdaTypeDictionary forKey:foodNumber];
		return nil;
	}
	NSMutableArray *foodRDAList=[rdaTypeDictionary objectForKey:userTypeNumber];
	if(!foodRDAList)
	{
		return nil;
	}
	return foodRDAList;
}
+(void)setFoodRDAcache:(NSNumber *)foodNumber forUserType:(int)userType WithRDAarray:(NSMutableArray *)arrayRDA
{
	NSNumber *userTypeNumber = [[NSNumber alloc] initWithInt:userType];
		
	if(!foodRDAdictionary){
		foodRDAdictionary= [[NSMutableDictionary alloc]init];
	}
	
	NSMutableDictionary *rdaTypeDictionary=[foodRDAdictionary objectForKey:foodNumber];
	if(!rdaTypeDictionary)
	{
		rdaTypeDictionary= [[NSMutableDictionary alloc]init];
		[foodRDAdictionary setObject:rdaTypeDictionary forKey:foodNumber];
	}
	[rdaTypeDictionary setObject:arrayRDA forKey:userTypeNumber];
}
+(NSMutableArray *)multiplyFoodRDAWithGram:(NSMutableArray *)cacheArray weight:(double)gram
{
	NSMutableArray * array=[[NSMutableArray alloc] init];
	// copy value and calculate percentage
	FoodNutrient *rdaNutrient;
	for(int i = 0; i < cacheArray.count; i++){
		FoodNutrient *source=(FoodNutrient *)[cacheArray objectAtIndex:i];
		rdaNutrient = [source cloneFoodNutrient];
		[rdaNutrient setRdaRatio:((gram/100) * [rdaNutrient rda100gRatio])];
		[rdaNutrient setNutrientValue:((gram/100) *[rdaNutrient nutrient100gValue])];
		[array addObject:rdaNutrient];
	}
	return array;
}

+(NSMutableArray *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int) userType weight:(double)gram
{
	// use a cache here to improve the performance
	NSMutableArray *cacheArray=[OmniTool getFoodRDAcache:foodNumber forUserType:userType];
	if(cacheArray!=nil)
	{
		return [OmniTool multiplyFoodRDAWithGram:cacheArray weight:gram];
	}
	
	NSMutableArray *array = [OmniTool getFoodNutrientOnlyInRDA:foodNumber];
	NSMutableArray *arrayRDA = [OmniTool getRDAList:userType];
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

	if(foodNumber==nil){
		NSLog(@"getFoodRDA: foodNumber is nil!!");
		return array;
	}
	

	// retrieve the nutrients in the given food, save into dictionary with nutrient as key
	FoodNutrient *foodNutrient;
	for(int i = 0; i < array.count; i++){
		foodNutrient = [array objectAtIndex:i];
		[dic setObject:foodNutrient forKey:((NSNumber *)[foodNutrient nutrientNumber])];
	}
	

	// copy value and calculate percentage
	// for each RDA nutrient, copy the actual value and calculate RDA ratio
	FoodNutrient *rdaNutrient;
	for(int i = 0; i < arrayRDA.count; i++){
	  	rdaNutrient = [arrayRDA objectAtIndex:i];
	  	foodNutrient=[dic objectForKey:((NSNumber *)[rdaNutrient nutrientNumber])];
		if(foodNutrient!=nil){
				
			[rdaNutrient setFoodNumber:[foodNutrient foodNumber]];
			[rdaNutrient setRdaRatio:([foodNutrient nutrientValue]/[rdaNutrient nutrientValue])];
			[rdaNutrient setNutrientValue:[foodNutrient nutrientValue]];

			[rdaNutrient setRda100gRatio:[rdaNutrient rdaRatio]];
			[rdaNutrient setNutrient100gValue:[foodNutrient nutrientValue]];
		}else{
			[rdaNutrient setFoodNumber:foodNumber];
			[rdaNutrient setRdaRatio:0];
			[rdaNutrient setRda100gRatio:0];
			[rdaNutrient setNutrientValue:0];
			[rdaNutrient setNutrient100gValue:0];
		}

	}

	[OmniTool setFoodRDAcache:foodNumber forUserType:userType WithRDAarray:arrayRDA];


	arrayRDA=[OmniTool multiplyFoodRDAWithGram:arrayRDA weight:gram];

	return arrayRDA;
}
+(NSArray *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int)userType weight:(double)gram nutrientType:(NSString *)nutrientType sortOrder:(int) sortOrder
{
	NSMutableArray *array = [OmniTool getFoodRDA:foodNumber forUserType:userType weight:gram];
	NSMutableArray *arrayMatchType=[[NSMutableArray alloc]init];
	NSArray *sortedArray;
	NSSortDescriptor *sortDescriptor;
	NSArray *sortDescriptors ;
		
	id foodNutrient;
	NSString *foodNutrientType;
	for(int i = 0; i < array.count; i++){
  		foodNutrient = [array objectAtIndex:i];
  		foodNutrientType = [foodNutrient nutrientType];
	  	if([foodNutrientType isEqualToString:nutrientType])
	  	{
	  		// only add those who match  nutrient type
			[arrayMatchType addObject:foodNutrient];
	  	}
	}
	// order: 0 = official site order ascending
	//			1 = rdaRatio order descending
	//			2 = nutrientValue order descending
	switch(sortOrder){
		case 0:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchOrder" ascending:YES];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
		case 1:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rdaRatio" ascending:NO];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
		case 2:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nutrientValue" ascending:NO];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
	}
	
	return sortedArray;
}
+(FoodNutrient *)getFoodRDA:(NSNumber *)foodNumber forUserType:(int)userType weight:(double)gram nutrientType:(NSString *)nutrientType AndNutrientNumber:(NSNumber *)nutrientNumber sortOrder:(int) sortOrder
{
	NSMutableArray *array = [OmniTool getFoodRDA:foodNumber forUserType:userType weight:gram];
	NSMutableArray *arrayMatchType=[[NSMutableArray alloc]init];
	NSArray *sortedArray;
	NSSortDescriptor *sortDescriptor;
	NSArray *sortDescriptors ;
	  
	id foodNutrient;
	NSString *foodNutrientType;
	  NSNumber *nutrientNum;
	  for(int i = 0; i < array.count; i++){
	  	foodNutrient = [array objectAtIndex:i];
	      foodNutrientType = [foodNutrient nutrientType];
	      nutrientNum = [foodNutrient nutrientNumber];
	  	if([foodNutrientType isEqualToString:nutrientType] && [nutrientNum isEqualToNumber:nutrientNumber])
	  	{
	  		// only add those who match  nutrient type
			[arrayMatchType addObject:foodNutrient];
	  	}
	  }
	// order: 0 = official site order ascending
	//			1 = rdaRatio order descending
	//			2 = nutrientValue order descending
	switch(sortOrder){
		case 0:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchOrder" ascending:YES];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
		case 1:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rdaRatio" ascending:NO];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
		case 2:
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nutrientValue" ascending:NO];
			sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			sortedArray = [arrayMatchType sortedArrayUsingDescriptors:sortDescriptors];
			break;
	}
	  
	  FoodNutrient *SendfoodNutrient;
	  SendfoodNutrient = [sortedArray objectAtIndex:0];
	return SendfoodNutrient;
}


+(void) clearSearch{ // 清除 search logs
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *updateSql;
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
	}
	
	// delete  record
	updateSql = [NSString stringWithFormat:@"DELETE FROM food_search_log"];
	  [db executeUpdate:updateSql];
	updateSql = [NSString stringWithFormat:@"DELETE FROM food_search_count"];
	  [db executeUpdate:updateSql];
	
	[db close];

}


// if disconnected, return nil
// else, return 
+(CBPeripheral *)getCurrentConnectionStatus
{
	  
	CBPeripheral *ap=[[(AppDelegate *)[[UIApplication sharedApplication] delegate] btModule] activePeripheral];
	if(ap.state==CBPeripheralStateConnected){
		return ap;
	}else{
		return nil;
	}
}
// scan devices for t seconds
+(void)scanBT4device:(float) t
{
	NSLog(@"start scan device...");
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate btModule] findBLEPeripherals:2];
	  [NSTimer scheduledTimerWithTimeInterval:(float)t target:appDelegate selector:@selector(scanTimer:) userInfo:nil repeats:NO];
}

// return a list of CBPeripheral
+(NSMutableArray*)getDeviceList
{
	AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
	return [[appDelegate btModule] peripherals];
}
+(FoodOverview *)getFoodOverview:(NSNumber *)foodNumber forUserType:(int) userType weight:(float)gram
{
    // NSLog(@"getFoodOverview with %f gram",gram);
	FoodOverview *overview=[FoodOverview alloc];
	if(foodNumber==nil){
		NSLog(@"Error: getFoodOverview: foodNumber=nil");
		return overview;
	}
	NSMutableArray *array = [OmniTool getFoodRDA:foodNumber forUserType:userType weight:gram];
    NSMutableArray *foodNutrientArray=[[NSMutableArray alloc] init];
	double  energyRatio;
	double  fatRatio;
	double  sugarRatio;
	double  sodiumRatio;
	double  otherRatio;

	FoodNutrient *foodNutrient;
	  for(int i = 0; i < array.count; i++){
	  	foodNutrient = (FoodNutrient *)[array objectAtIndex:i];
		if([[foodNutrient nutrientNumber] intValue]==208)  [overview setNutrientEnergyKcal      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==262)  [overview setNutrientCaffeine        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==301)  [overview setNutrientCalcium         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==205)  [overview setNutrientCarbohydrate    :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==601)  [overview setNutrientCholesterol     :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==421)  [overview setNutrientCholine         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==312)  [overview setNutrientCopper          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==291)  [overview setNutrientFiber           :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==313)  [overview setNutrientFluoride        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==417)  [overview setNutrientFolate          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==303)  [overview setNutrientIron            :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==304)  [overview setNutrientMagnesium       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==315)  [overview setNutrientManganese       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==406)  [overview setNutrientNiacin          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==410)  [overview setNutrientPantothenicacid :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==305)  [overview setNutrientPhosphorus      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==306)  [overview setNutrientPotassium       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==203)  [overview setNutrientProtein         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==405)  [overview setNutrientRiboflavin      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==317)  [overview setNutrientSelenium        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==307)  [overview setNutrientSodium          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==269)  [overview setNutrientSugars          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==404)  [overview setNutrientThiamin         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==204)  [overview setNutrientTotallipid      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==320)  [overview setNutrientVitaminA        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==418)  [overview setNutrientVitaminB12      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==415)  [overview setNutrientVitaminB6       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==401)  [overview setNutrientVitaminC        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==328)  [overview setNutrientVitaminD        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==323)  [overview setNutrientVitaminE        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==430)  [overview setNutrientVitaminK        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==255)  [overview setNutrientWater           :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==309)  [overview setNutrientZinc	        :foodNutrient];
          
          
          if([[foodNutrient nutrientNumber] intValue]==208)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==262)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==301)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==205)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==601)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==421)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==312)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==291)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==313)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==417)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==303)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==304)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==315)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==406)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==410)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==305)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==306)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==203)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==405)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==317)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==307)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==269)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==404)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==204)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==320)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==418)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==415)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==401)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==328)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==323)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==430)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==255)  [foodNutrientArray addObject:foodNutrient];
          if([[foodNutrient nutrientNumber] intValue]==309)  [foodNutrientArray addObject:foodNutrient];

	  }
	  energyRatio=[[overview nutrientEnergyKcal] rdaRatio];
	  fatRatio=[[overview nutrientTotallipid] rdaRatio];
	sugarRatio=[[overview nutrientSugars] rdaRatio];
	sodiumRatio=[[overview nutrientSodium] rdaRatio];
	
	otherRatio=	([[overview nutrientCaffeine ] rdaRatio]+
				[[overview nutrientCalcium ] rdaRatio]+
				[[overview nutrientCarbohydrate ] rdaRatio]+
				[[overview nutrientCholesterol ] rdaRatio]+
				[[overview nutrientCholine ] rdaRatio]+
				[[overview nutrientCopper ] rdaRatio]+
				[[overview nutrientFiber ] rdaRatio]+
				[[overview nutrientFluoride ] rdaRatio]+
				[[overview nutrientFolate ] rdaRatio]+
				[[overview nutrientIron ] rdaRatio]+
				[[overview nutrientMagnesium ] rdaRatio]+
				[[overview nutrientManganese ] rdaRatio]+
				[[overview nutrientNiacin ] rdaRatio]+
				[[overview nutrientPantothenicacid ] rdaRatio]+
				[[overview nutrientPhosphorus ] rdaRatio]+
				[[overview nutrientPotassium ] rdaRatio]+
				[[overview nutrientProtein ] rdaRatio]+
				[[overview nutrientRiboflavin ] rdaRatio]+
				[[overview nutrientSelenium ] rdaRatio]+
				[[overview nutrientThiamin ] rdaRatio]+
				[[overview nutrientVitaminA ] rdaRatio]+
				[[overview nutrientVitaminB12 ] rdaRatio]+
				[[overview nutrientVitaminB6 ] rdaRatio]+
				[[overview nutrientVitaminC ] rdaRatio]+
				[[overview nutrientVitaminD ] rdaRatio]+
				[[overview nutrientVitaminE ] rdaRatio]+
				[[overview nutrientVitaminK ] rdaRatio]+
				[[overview nutrientWater ] rdaRatio]+
				[[overview nutrientZinc ] rdaRatio]) /29;

	[overview setEnergyRatio      :energyRatio];
	[overview setFatRatio		:fatRatio];
	[overview setSugarRatio         :sugarRatio];
	[overview setSodiumRatio      :sodiumRatio];
	[overview setOtherRatio      :otherRatio];
		

    // sort the FoodNutrients according to nutrientShortName
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nutrientShortName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	sortedArray = [foodNutrientArray sortedArrayUsingDescriptors:sortDescriptors];
    
	[overview setRdaFoodNutrientArray:sortedArray];
    
	return overview;
}
+(void) disconnectFromCurrentPeripheral
{
	  TIBLECBKeyfob *btModule;   //藍牙模組。
	  btModule = [(AppDelegate *)[[UIApplication sharedApplication] delegate] btModule];
	if (btModule.activePeripheral && btModule.activePeripheral.state==CBPeripheralStateConnected){
		NSLog(@"disconnectFromCurrentPeripheral...");
		[[btModule CM] cancelPeripheralConnection:[btModule activePeripheral]];
	}
}
+(NSString *)UUIDtoString:(CFUUIDRef) UUID
{
	  TIBLECBKeyfob *btModule;   //
	  btModule = [(AppDelegate *)[[UIApplication sharedApplication] delegate] btModule];
	  return [btModule UUIDToNSString:UUID];
}
+(double) getCurrentGram
{
	  switch(inputWeightUnit){
	  	case UNIT_LB:
			return simulatedWeight*453.59237;
			break;
	  	case UNIT_OZ:
			return simulatedWeight*28.3495231;
			break;
	  	case UNIT_G:
		default:
			return simulatedWeight;
			break;
	  }
}


/*
 weight simulation algorithm
 1. update frequency > weight update frequency
 2. maintain volocity vector for each update, until target weight is reached
 3. TARE command: cancel simulation
 
 variables:
 	input weight from scale
 		inputWeight
 		inputWeightUnit
 	simulated weight for smooth display
 		simulatedWeight
 		simulatedWeightUnit = inpurWeightUnit
 		targetSimulationWeight
 		simulationVelocity
 	translated weight for user selected unit
 		translatedWeight
 		translatedWeightUnit

*/
+(double) weightSimulation:(double)targetWeight
{
	targetSimulationWeight=targetWeight;
	simulatedWeight=targetWeight;

/* cancel simulation for now
	// target was changed
	if(targetWeight!=targetSimulationWeight){
		// update target simulation weight
		targetSimulationWeight=targetWeight;
		// update simulationVelocity
		simulationVelocity = (targetSimulationWeight-simulatedWeight)/5;
	}
	
	if(simulatedWeight!=targetSimulationWeight){
		// proceed simulation
		simulatedWeight+=simulationVelocity;
		
		// if simulationVelocity is positive
		if(simulationVelocity>0){
			if(simulatedWeight > targetSimulationWeight)
				simulatedWeight=targetSimulationWeight;
		}else if (simulationVelocity < 0){
			if(simulatedWeight < targetSimulationWeight)
				simulatedWeight=targetSimulationWeight;
		}else{	// simulationVelocity =0
			simulatedWeight=targetSimulationWeight;
		}
	}
*/
//	NSLog(@"weightSimulation:%f->%f",targetWeight,simulatedWeight);
	return simulatedWeight;
}
/*
Test Codes:
	double g,lb;
	for(g=0;g<100;g++){
		lb=[OmniTool unitConvert:g SourceUnit:UNIT_G TargetUnit:UNIT_LB];
		NSLog(@"%f(g) -> %f(lb) -> %.3f(lb)",g,lb,lb);
	}
Execution Result:
2013-06-23 07:46:26.782 iPadNutritionScaleWithStoryBoard[5672:13d03] 0.000000(g) -> 0.000000(lb) -> 0.000(lb)
2013-06-23 07:46:26.783 iPadNutritionScaleWithStoryBoard[5672:13d03] 1.000000(g) -> 0.002205(lb) -> 0.002(lb)
2013-06-23 07:46:26.784 iPadNutritionScaleWithStoryBoard[5672:13d03] 2.000000(g) -> 0.004409(lb) -> 0.004(lb)
2013-06-23 07:46:26.785 iPadNutritionScaleWithStoryBoard[5672:13d03] 3.000000(g) -> 0.006614(lb) -> 0.007(lb)
2013-06-23 07:46:26.786 iPadNutritionScaleWithStoryBoard[5672:13d03] 4.000000(g) -> 0.008818(lb) -> 0.009(lb)
2013-06-23 07:46:26.786 iPadNutritionScaleWithStoryBoard[5672:13d03] 5.000000(g) -> 0.011023(lb) -> 0.011(lb)
...
2013-06-23 07:46:26.957 iPadNutritionScaleWithStoryBoard[5672:13d03] 92.000000(g) -> 0.202825(lb) -> 0.203(lb)
2013-06-23 07:46:26.958 iPadNutritionScaleWithStoryBoard[5672:13d03] 93.000000(g) -> 0.205030(lb) -> 0.205(lb)
2013-06-23 07:46:26.959 iPadNutritionScaleWithStoryBoard[5672:13d03] 94.000000(g) -> 0.207235(lb) -> 0.207(lb)
2013-06-23 07:46:26.960 iPadNutritionScaleWithStoryBoard[5672:13d03] 95.000000(g) -> 0.209439(lb) -> 0.209(lb)
2013-06-23 07:46:26.961 iPadNutritionScaleWithStoryBoard[5672:13d03] 96.000000(g) -> 0.211644(lb) -> 0.212(lb)
2013-06-23 07:46:26.962 iPadNutritionScaleWithStoryBoard[5672:13d03] 97.000000(g) -> 0.213848(lb) -> 0.214(lb)
2013-06-23 07:46:26.963 iPadNutritionScaleWithStoryBoard[5672:13d03] 98.000000(g) -> 0.216053(lb) -> 0.216(lb)
2013-06-23 07:46:26.964 iPadNutritionScaleWithStoryBoard[5672:13d03] 99.000000(g) -> 0.218258(lb) -> 0.218(lb)
2013-06-23 07:46:26.965 iPadNutritionScaleWithStoryBoard[5672:13d03] Execution time=0.183 second(s).

*/
+(double)unitConvert:(double) weightValue SourceUnit:(int)sourceUnit TargetUnit:(int)targetUnit
{
	double convertWeigh=weightValue;
	switch(sourceUnit)
	{
	      case UNIT_G:
	          switch(targetUnit)
			{
	            case UNIT_LB:
	                convertWeigh = weightValue*0.00220462262; 
	                break;
	            case UNIT_OZ:
	                convertWeigh = weightValue*0.0352739619;
	                break;
	            case UNIT_CATTY:
	                convertWeigh = weightValue/600;
	                break;
	            case UNIT_TAEL:
	                convertWeigh = weightValue/37.5;
	                break;
	            case UNIT_CHIAN:
	                convertWeigh = weightValue/3.75;
	                break;
			}
	          break;
	      case UNIT_LB:
	      default:
	          switch(targetUnit)
			{
	            case UNIT_G:
	                convertWeigh = weightValue*453.59237;
	                break;
	            case UNIT_OZ:
	                convertWeigh = weightValue*16;
	                break;
	            case UNIT_CATTY:
	                convertWeigh = weightValue*0.755987283;
	                break;
	            case UNIT_TAEL:
	                convertWeigh = weightValue*12.09579653;
	                break;
	            case UNIT_CHIAN:
	                convertWeigh = weightValue*120.9579653;
	                break;
			}
	          break;
	}
	// NSLog(@"unitConvert: %f  %d  %d ==> %f",weightValue,sourceUnit,targetUnit,convertWeigh);
	return convertWeigh;
}

+(void) seperateTitleSubtitle:(Food *)food
{
	NSString *delimiter = @",";
	NSRange delimiterPosition = [food.longDescription rangeOfString:delimiter];
	NSRange secondDelimiterPosition;
	if(delimiterPosition.location==NSNotFound){
		// only 1 word
		food.title=food.longDescription;
		food.subTitle=@"";
	}else{
		NSString *firstSectionString = [food.longDescription substringToIndex:delimiterPosition.location+ delimiterPosition.length];
		NSString *stringAfterFirstComma = [food.longDescription substringFromIndex:delimiterPosition.location + delimiterPosition.length];
		
		secondDelimiterPosition = [stringAfterFirstComma rangeOfString:delimiter];
		if(secondDelimiterPosition.location==NSNotFound){
			
			food.title=[firstSectionString stringByAppendingString:stringAfterFirstComma];
			food.subTitle=@"";
		}else{
			NSString *secondSectionString = [stringAfterFirstComma substringToIndex:secondDelimiterPosition.location];
            
			food.title=[firstSectionString stringByAppendingString:secondSectionString];
			food.subTitle=	[[stringAfterFirstComma substringFromIndex:secondDelimiterPosition.location + secondDelimiterPosition.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
			// fix string with first char upper case
			food.subTitle =[food.subTitle lowercaseString];
			food.subTitle =[food.subTitle stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[food.subTitle substringToIndex:1] capitalizedString]];
		}
	}
}
+(NSMutableDictionary *)getMostRecentSearched
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	NSMutableArray *recent=[OmniTool recentSearch];
	[dic setObject:recent forKey:@"Recent Searched"];
	
	NSMutableArray *most=[OmniTool mostSearch];
	[dic setObject:most forKey:@"Most Searched"];
	return dic;
}

+(NSMutableDictionary *)recommendFoodSearch:(NSString *) keyword
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *likeParameter = [NSString stringWithFormat:@"%@%%", keyword];
	int recordCount=20;
		
	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return nil;
	}
	
	// those who started with keyword
	// NSString *sql=[NSString stringWithFormat:@"SELECT * FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount];
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no ,food_des.long_desc ,food_des.shrt_desc ,fd_group.fdgrp_desc ,fd_group.fdgrp_cd FROM food_des,fd_group WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND long_desc LIKE ? LIMIT 0,%d",recordCount]; 
	FMResultSet *rs=[db executeQuery:sql,likeParameter];
//    NSLog(@"sql = %@ , %@", sql, likeParameter);
	if (!rs)
	{
	    NSLog(@"error1: %@", [db lastErrorMessage]);
	      
	    [db close];
		[dic setObject:array forKey:@"Recommend Search"];
	    return dic;
	}

	while([rs next]){
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
//		[f setFactorCarbohydrate:[rs doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs doubleForColumn:@"n_factor"]];
		[OmniTool seperateTitleSubtitle:f];
		[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
		[array addObject:f];
	}


	[db close];

	[dic setObject:array forKey:@"Recommend Search"];
	return dic;
}

+(NSMutableDictionary *)searchFoodWithTitle:(NSString *) keyword
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	
	NSMutableArray *foodArray=[OmniTool searchFood:(NSString *) keyword RecordCount:50];
	[dic setObject:foodArray forKey:@"Search Result"];
	return dic;
}

+(NSString *)connectionStateToString:(ConnectionState) connState
{
/*
typedef enum {
	CONNECTION_STATE_BT_NOT_READY,	// Initial, BT not start
	CONNECTION_STATE_BT_READY,	// BT ready, waiting for order ,activePeripheral =nil
	CONNECTION_STATE_SEARCHING,	// searching for peripherals, either activeperipheral connected or not
	CONNECTION_STATE_CONNECTED,	// Connected, not scanning
	CONNECTION_STATE_NOT_CONNECTED,	// activePeripheral not nil, not connected
	CONNECTION_STATE_CONNECTING,
	CONNECTION_STATE_CONNECTION_FAILD
} ConnectionState;
*/
	switch(connState)
	{
		case CONNECTION_STATE_BT_NOT_READY:
			return @"CONNECTION_STATE_BT_NOT_READY";
		case  CONNECTION_STATE_BT_READY:
			return @"CONNECTION_STATE_BT_READY";
		case  CONNECTION_STATE_SEARCHING:
			return @"CONNECTION_STATE_SEARCHING";
		case  CONNECTION_STATE_CONNECTED:
			return @"CONNECTION_STATE_CONNECTED";
		case  CONNECTION_STATE_NOT_CONNECTED:
			return @"CONNECTION_STATE_NOT_CONNECTED";
		case  CONNECTION_STATE_CONNECTING:
			return @"CONNECTION_STATE_CONNECTING";
		case  CONNECTION_STATE_CONNECTION_FAILD:
			return @"CONNECTION_STATE_CONNECTION_FAILD";
		default:
			return @"CONNECTION_STATE UNKNOWN";
	}
}


+(void) printTime:(CFAbsoluteTime) pTime
{
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		pTime,
		currentTimeZone
	);
	int dayOfWeek=(int)CFAbsoluteTimeGetDayOfWeek(pTime,currentTimeZone);
    CFRelease(currentTimeZone);
	NSLog(@"Current Date Time:=  year(%d) month(%d) day(%d) hour(%d) minute(%d) second(%f), weekday(%d)",
	  (int)cfg.year,
	  (int)cfg.month,
	  (int)cfg.day,
	  (int)cfg.hour,
	  (int)cfg.minute,
	  cfg.second
	  ,dayOfWeek);
}

+(void) testTimeFunctions
{
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFAbsoluteTime currentTime=CFAbsoluteTimeGetCurrent();
	
	// print out Current Date Time:=  year(2013) month(7) day(4) hour(20) minute(3) second(13.684803)
	[OmniTool printTime:currentTime];

	CFGregorianUnits day1 = {0, 0, 1, 0, 0, 0};
	CFAbsoluteTime tomorrow=CFAbsoluteTimeAddGregorianUnits(currentTime,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];

	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
	tomorrow=CFAbsoluteTimeAddGregorianUnits(tomorrow,currentTimeZone,day1);
	[OmniTool printTime:tomorrow];
    
    CFRelease(currentTimeZone);
/*
2013-07-04 20:16:22.500 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(4) hour(20) minute(16) second(22.497074), weekday(4)
2013-07-04 20:16:22.502 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(5) hour(20) minute(16) second(22.497074), weekday(5)
2013-07-04 20:16:22.504 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(6) hour(20) minute(16) second(22.497074), weekday(6)
2013-07-04 20:16:22.506 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(7) hour(20) minute(16) second(22.497074), weekday(7)
2013-07-04 20:16:22.507 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(8) hour(20) minute(16) second(22.497074), weekday(1)
2013-07-04 20:16:22.509 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(9) hour(20) minute(16) second(22.497074), weekday(2)
2013-07-04 20:16:22.510 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(10) hour(20) minute(16) second(22.497074), weekday(3)
2013-07-04 20:16:22.511 iPadNutritionScaleWithStoryBoard[21836:907] Current Date Time:=  year(2013) month(7) day(11) hour(20) minute(16) second(22.497074), weekday(4)
*/

	[OmniTool printTime:[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()]];
/*
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		currentTime,
		currentTimeZone
	);
	int dayOfWeek=(int)CFAbsoluteTimeGetDayOfWeek(currentTime,currentTimeZone);
	cfg.hour=0;
	cfg.minute=0;
	cfg.second=0;
	CFAbsoluteTime todayMorningTime=CFGregorianDateGetAbsoluteTime(cfg,currentTimeZone);
	CFGregorianUnits dayMonday = {0, 0, 1-dayOfWeek, 0, 0, 0};
	CFAbsoluteTime mondayMorningTime=CFAbsoluteTimeAddGregorianUnits(todayMorningTime,currentTimeZone,dayMonday);
	[OmniTool printTime:mondayMorningTime];
	
	
	 */
}
// return monday morning 00:00:00 absolute time
+(CFAbsoluteTime) getMondayMorningTime:(CFAbsoluteTime) absoluteTime
{
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		absoluteTime,
		currentTimeZone
	);
	int dayOfWeek=(int)CFAbsoluteTimeGetDayOfWeek(absoluteTime,currentTimeZone);
	cfg.hour=0;
	cfg.minute=0;
	cfg.second=0;
	CFAbsoluteTime todayMorningTime=CFGregorianDateGetAbsoluteTime(cfg,currentTimeZone);
	CFGregorianUnits dayMonday = {0, 0, 1-dayOfWeek, 0, 0, 0};
	CFAbsoluteTime mondayMorningTime=CFAbsoluteTimeAddGregorianUnits(todayMorningTime,currentTimeZone,dayMonday);
    CFRelease(currentTimeZone);
	return mondayMorningTime;
}
// return morning 00:00:00 absolute time
+(CFAbsoluteTime) getMorningTime:(CFAbsoluteTime) absoluteTime
{
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		absoluteTime,
		currentTimeZone
	);
    
	cfg.hour=0;
	cfg.minute=0;
	cfg.second=0;
    
    CFAbsoluteTime returnTime = CFGregorianDateGetAbsoluteTime(cfg,currentTimeZone);
    CFRelease(currentTimeZone);
	return returnTime;
    
}

// log foods taken
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double) gram 
{
	[OmniTool logFoodTaken:foodNumber WeightGram:gram AtTime:CFAbsoluteTimeGetCurrent()];
}
// log foods taken at given time
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram AtTime:(CFAbsoluteTime)takenTime
{
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *updateSql;
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return;
	}

	updateSql = [NSString stringWithFormat:@"INSERT INTO food_taken_log(ndb_no,food_weight,taken_time) VALUES(%d,%f,%f)", [foodNumber intValue],gram,takenTime];
	[db executeUpdate:updateSql];
	
	[db close];
}

+(NSMutableArray *)addNutrientArray:(NSMutableArray *)targetArray sourceNutrientArray:(NSMutableArray *)sourceArray
{
	bool found;
	if(!targetArray || !sourceArray)	return targetArray;
	NSMutableArray * resultArray=[[NSMutableArray alloc]init];
	
	for(FoodNutrient *sourceFoodNutrient in sourceArray){
		found=false;
		for(FoodNutrient *targetFoodNutrient in targetArray){
			if([targetFoodNutrient.nutrientNumber intValue]==[sourceFoodNutrient.nutrientNumber intValue])
			{
				found=true;
				[resultArray addObject:[OmniTool addFoodNutrient:targetFoodNutrient sourceFoodNutrient:sourceFoodNutrient]];
			}
		}
		if(found==false){
			[resultArray addObject:sourceFoodNutrient];
		}
	}
	return resultArray;
}
// add the nutrientValue and RDA percent
+(FoodNutrient *) addFoodNutrient:(FoodNutrient *)targetFoodNutrient sourceFoodNutrient:(FoodNutrient *)sourceFoodNutrient
{
	[targetFoodNutrient setNutrientValue:([targetFoodNutrient nutrientValue]+[sourceFoodNutrient nutrientValue])];
	[targetFoodNutrient setRdaRatio:([targetFoodNutrient rdaRatio]+[sourceFoodNutrient rdaRatio])];
	
	[targetFoodNutrient setNutrient100gValue:([targetFoodNutrient nutrient100gValue]+[sourceFoodNutrient nutrient100gValue])];
	[targetFoodNutrient setRda100gRatio:([targetFoodNutrient rda100gRatio]+[sourceFoodNutrient rda100gRatio])];
	return targetFoodNutrient;
}
+(void) clearFoodTakenLog{ // 清除 search logs
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *updateSql;
		
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
	}
	
	// delete  record
	updateSql = [NSString stringWithFormat:@"DELETE FROM food_taken_log"];
	  [db executeUpdate:updateSql];
	
	[db close];

}
// get the total nutrients taken today
// user Type: 0=woman, 1=man, default is 1
+(FoodNutrientDayLog *) getNutrientsTakenToday:(int)userType
{
	NSMutableDictionary * numberWeightDictionary=[[NSMutableDictionary alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSNumber *foodNumber;
	NSNumber *sumWeight;
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}
	
	  FoodNutrientDayLog *dayLog=[[FoodNutrientDayLog alloc] init];
	// current time
	CFAbsoluteTime currentTime=CFAbsoluteTimeGetCurrent();
	
	// calculate the start time of today
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		currentTime,
		currentTimeZone
	);
	cfg.hour=0;
	cfg.minute=0;
	cfg.second=0;
	CFAbsoluteTime todayMorningTime=CFGregorianDateGetAbsoluteTime(cfg,currentTimeZone);
	[dayLog setWeekDay:(int)CFAbsoluteTimeGetDayOfWeek(currentTime,currentTimeZone)];
    CFRelease(currentTimeZone);
	[dayLog setDateString:[NSString stringWithFormat:@"%d/%d",cfg.month,cfg.day]];


	// sum the food numbers and grams between todayMorningTime and currentTime
	// SELECT ndb_no,SUM(food_weight) AS fw FROM food_taken_log WHERE taken_time >=todayMorningTime AND taken_time <currentTime GROUP BY ndb_no
	NSString *sql=[NSString stringWithFormat:@"SELECT ndb_no,SUM(food_weight) AS fw FROM food_taken_log WHERE taken_time >=%.0f AND taken_time <%.0f GROUP BY ndb_no",todayMorningTime,currentTime+1];
	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		foodNumber=[[NSNumber alloc] initWithInt:[rs intForColumn:@"ndb_no"]];
		sumWeight=[[NSNumber alloc] initWithDouble:[rs doubleForColumn:@"fw"]];
		[numberWeightDictionary setObject:sumWeight forKey:foodNumber];
	}

	[db close];

	
	NSEnumerator *enumerator = [numberWeightDictionary keyEnumerator];

	while ((foodNumber = [enumerator nextObject])) {
		double weight=[(NSNumber *)[numberWeightDictionary objectForKey:foodNumber] doubleValue];

		// getFoodNutrients for this food
		NSMutableArray *foodNutrientArray=[OmniTool getFoodRDA:foodNumber forUserType:userType weight:weight];
		// sum into the array
		[dayLog setSumFoodNutrientArray:[OmniTool addNutrientArray:dayLog.sumFoodNutrientArray sourceNutrientArray:foodNutrientArray]];
	}


	[OmniTool computeFoodOverview:dayLog];

	return dayLog;
}

// retrieve FoodOverview from FoodNutrient Array
+(void)computeFoodOverview:(FoodNutrientDayLog *)foodNutrientDayLog 
{
	if(!foodNutrientDayLog) return;
	FoodOverview *overview=[[FoodOverview alloc] init];
	
	NSMutableArray *array = [foodNutrientDayLog sumFoodNutrientArray];
	if(!array) return;
	
	double  energyRatio;
	double  fatRatio;
	double  sugarRatio;
	double  sodiumRatio;
	double  otherRatio;

	FoodNutrient *foodNutrient;
	for(int i = 0; i < array.count; i++){
	  	foodNutrient = (FoodNutrient *)[array objectAtIndex:i];
		if([[foodNutrient nutrientNumber] intValue]==208)  [overview setNutrientEnergyKcal      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==262)  [overview setNutrientCaffeine        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==301)  [overview setNutrientCalcium         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==205)  [overview setNutrientCarbohydrate    :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==601)  [overview setNutrientCholesterol     :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==421)  [overview setNutrientCholine         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==312)  [overview setNutrientCopper          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==291)  [overview setNutrientFiber           :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==313)
		{
			[overview setNutrientFluoride        :foodNutrient];
		}
		if([[foodNutrient nutrientNumber] intValue]==417)
		{
			[overview setNutrientFolate          :foodNutrient];
/*
			NSLog(@"-----------------------------------------------");
			NSLog(@" computeFoodOverview print setNutrientFolate");
			[foodNutrient printInfo];
			[[overview nutrientFolate] printInfo];
			NSLog(@"-----------------------------------------------");
*/
		}
			
		if([[foodNutrient nutrientNumber] intValue]==303)  [overview setNutrientIron            :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==304)  [overview setNutrientMagnesium       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==315)  [overview setNutrientManganese       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==406)  [overview setNutrientNiacin          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==410)  [overview setNutrientPantothenicacid :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==305)  [overview setNutrientPhosphorus      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==306)  [overview setNutrientPotassium       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==203)  [overview setNutrientProtein         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==405)  [overview setNutrientRiboflavin      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==317)  [overview setNutrientSelenium        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==307)  [overview setNutrientSodium          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==269)  [overview setNutrientSugars          :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==404)  [overview setNutrientThiamin         :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==204)  [overview setNutrientTotallipid      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==320)  [overview setNutrientVitaminA        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==418)  [overview setNutrientVitaminB12      :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==415)  [overview setNutrientVitaminB6       :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==401)  [overview setNutrientVitaminC        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==328)  [overview setNutrientVitaminD        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==323)  [overview setNutrientVitaminE        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==430)  [overview setNutrientVitaminK        :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==255)  [overview setNutrientWater           :foodNutrient];
		if([[foodNutrient nutrientNumber] intValue]==309)  [overview setNutrientZinc	        :foodNutrient];

	}
	energyRatio=[[overview nutrientEnergyKcal] rdaRatio];
	fatRatio=[[overview nutrientTotallipid] rdaRatio];
	sugarRatio=[[overview nutrientSugars] rdaRatio];
	sodiumRatio=[[overview nutrientSodium] rdaRatio];
	
	otherRatio=	([[overview nutrientCaffeine ] rdaRatio]+
				[[overview nutrientCalcium ] rdaRatio]+
				[[overview nutrientCarbohydrate ] rdaRatio]+
				[[overview nutrientCholesterol ] rdaRatio]+
				[[overview nutrientCholine ] rdaRatio]+
				[[overview nutrientCopper ] rdaRatio]+
				[[overview nutrientFiber ] rdaRatio]+
				[[overview nutrientFluoride ] rdaRatio]+
				[[overview nutrientFolate ] rdaRatio]+
				[[overview nutrientIron ] rdaRatio]+
				[[overview nutrientMagnesium ] rdaRatio]+
				[[overview nutrientManganese ] rdaRatio]+
				[[overview nutrientNiacin ] rdaRatio]+
				[[overview nutrientPantothenicacid ] rdaRatio]+
				[[overview nutrientPhosphorus ] rdaRatio]+
				[[overview nutrientPotassium ] rdaRatio]+
				[[overview nutrientProtein ] rdaRatio]+
				[[overview nutrientRiboflavin ] rdaRatio]+
				[[overview nutrientSelenium ] rdaRatio]+
				[[overview nutrientThiamin ] rdaRatio]+
				[[overview nutrientVitaminA ] rdaRatio]+
				[[overview nutrientVitaminB12 ] rdaRatio]+
				[[overview nutrientVitaminB6 ] rdaRatio]+
				[[overview nutrientVitaminC ] rdaRatio]+
				[[overview nutrientVitaminD ] rdaRatio]+
				[[overview nutrientVitaminE ] rdaRatio]+
				[[overview nutrientVitaminK ] rdaRatio]+
				[[overview nutrientWater ] rdaRatio]+
				[[overview nutrientZinc ] rdaRatio]) /29;

	[overview setEnergyRatio      :energyRatio];
	[overview setFatRatio		:fatRatio];
	[overview setSugarRatio         :sugarRatio];
	[overview setSodiumRatio      :sodiumRatio];
	[overview setOtherRatio      :otherRatio];
		
	[foodNutrientDayLog setFoodOverview:overview];
}
// return dictionary of FoodNutrientDayLog
// key: NSNumber  1=Monday, 2=Tuesday, etc
// value: FoodNutrientDayLog object
+(NSMutableDictionary *) getNutrientsTakenThisWeek: (int)userType
{
	NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
	// monday 00:00:00 time
	CFAbsoluteTime mondayMorning=[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()];

	FoodNutrientDayLog *day1Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning And:mondayMorning+SECONDS_IN_ONE_DAY];
	FoodNutrientDayLog *day2Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY And:mondayMorning+SECONDS_IN_ONE_DAY*2];
	FoodNutrientDayLog *day3Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*2 And:mondayMorning+SECONDS_IN_ONE_DAY*3];
	FoodNutrientDayLog *day4Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*3 And:mondayMorning+SECONDS_IN_ONE_DAY*4];
	FoodNutrientDayLog *day5Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*4 And:mondayMorning+SECONDS_IN_ONE_DAY*5];
	FoodNutrientDayLog *day6Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*5 And:mondayMorning+SECONDS_IN_ONE_DAY*6];
	FoodNutrientDayLog *day7Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*6 And:mondayMorning+SECONDS_IN_ONE_DAY*7];
	
	if(day1Log)	[dictionary setObject:day1Log forKey:[[NSNumber alloc] initWithInt:1]];
	if(day2Log)	[dictionary setObject:day2Log forKey:[[NSNumber alloc] initWithInt:2]];
	if(day3Log)	[dictionary setObject:day3Log forKey:[[NSNumber alloc] initWithInt:3]];
	if(day4Log)	[dictionary setObject:day4Log forKey:[[NSNumber alloc] initWithInt:4]];
	if(day5Log)	[dictionary setObject:day5Log forKey:[[NSNumber alloc] initWithInt:5]];
	if(day6Log)	[dictionary setObject:day6Log forKey:[[NSNumber alloc] initWithInt:6]];
	if(day7Log)	[dictionary setObject:day7Log forKey:[[NSNumber alloc] initWithInt:7]];
	return dictionary;
}
+(NSMutableDictionary *) getNutrientsTakenWithWeekBias:(int)weekBias UserType:(int)userType
{
	NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
	// monday 00:00:00 time
	CFAbsoluteTime mondayMorning=[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()];

	// calculate the week bias
	mondayMorning=mondayMorning + weekBias*SECONDS_IN_ONE_DAY*7;

	FoodNutrientDayLog *day1Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning And:mondayMorning+SECONDS_IN_ONE_DAY];
	FoodNutrientDayLog *day2Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY And:mondayMorning+SECONDS_IN_ONE_DAY*2];
	FoodNutrientDayLog *day3Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*2 And:mondayMorning+SECONDS_IN_ONE_DAY*3];
	FoodNutrientDayLog *day4Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*3 And:mondayMorning+SECONDS_IN_ONE_DAY*4];
	FoodNutrientDayLog *day5Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*4 And:mondayMorning+SECONDS_IN_ONE_DAY*5];
	FoodNutrientDayLog *day6Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*5 And:mondayMorning+SECONDS_IN_ONE_DAY*6];
	FoodNutrientDayLog *day7Log=[OmniTool getFoodNutrientDayLog:userType Between:mondayMorning+SECONDS_IN_ONE_DAY*6 And:mondayMorning+SECONDS_IN_ONE_DAY*7];
	
	if(day1Log)	[dictionary setObject:day1Log forKey:[[NSNumber alloc] initWithInt:1]];
	if(day2Log)	[dictionary setObject:day2Log forKey:[[NSNumber alloc] initWithInt:2]];
	if(day3Log)	[dictionary setObject:day3Log forKey:[[NSNumber alloc] initWithInt:3]];
	if(day4Log)	[dictionary setObject:day4Log forKey:[[NSNumber alloc] initWithInt:4]];
	if(day5Log)	[dictionary setObject:day5Log forKey:[[NSNumber alloc] initWithInt:5]];
	if(day6Log)	[dictionary setObject:day6Log forKey:[[NSNumber alloc] initWithInt:6]];
	if(day7Log)	[dictionary setObject:day7Log forKey:[[NSNumber alloc] initWithInt:7]];
	return dictionary;
}

// get the total nutrients taken between 2 timings
// user Type: 0=woman, 1=man, default is 1
+(FoodNutrientDayLog *) getFoodNutrientDayLog:(int)userType Between:(CFAbsoluteTime)startTime And:(CFAbsoluteTime)endTime
{
	NSMutableDictionary * numberWeightDictionary=[[NSMutableDictionary alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSNumber *foodNumber;
	NSNumber *sumWeight;
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return nil;
	}

	
	FoodNutrientDayLog *dayLog=[[FoodNutrientDayLog alloc] init];
	
	// calculate the start time of today
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
		startTime,
		currentTimeZone
	);
	[dayLog setWeekDay:(int)CFAbsoluteTimeGetDayOfWeek(startTime,currentTimeZone)];
    CFRelease(currentTimeZone);
	[dayLog setDateString:[NSString stringWithFormat:@"%d/%d",cfg.month,cfg.day]];
	[dayLog setYear:(int)cfg.year];
	[dayLog setMonth:(int)cfg.month];
	[dayLog setDay:(int)cfg.day];
	
	// sum the food numbers and grams between startTime and endTime
	// SELECT ndb_no,SUM(food_weight) AS fw FROM food_taken_log WHERE taken_time >=startTime AND taken_time <endTime GROUP BY ndb_no
	NSString *sql=[NSString stringWithFormat:@"SELECT ndb_no,SUM(food_weight) AS fw FROM food_taken_log WHERE taken_time >=%.0f AND taken_time <%.0f GROUP BY ndb_no",startTime,endTime];
	FMResultSet *rs=[db executeQuery:sql];
	while([rs next]){
		foodNumber=[[NSNumber alloc] initWithInt:[rs intForColumn:@"ndb_no"]];
		sumWeight=[[NSNumber alloc] initWithDouble:[rs doubleForColumn:@"fw"]];
// NSLog(@"Food take log (%f) - (%f), food(%d) weight=%f",startTime,endTime,[foodNumber intValue],[sumWeight doubleValue]);
		[numberWeightDictionary setObject:sumWeight forKey:foodNumber];
	}

	[db close];
	
	
	NSEnumerator *enumerator = [numberWeightDictionary keyEnumerator];

	while ((foodNumber = [enumerator nextObject])) {
		double weight=[(NSNumber *)[numberWeightDictionary objectForKey:foodNumber] doubleValue];
		// getFoodNutrients for this food
		NSMutableArray *foodNutrientArray=[OmniTool getFoodRDA:foodNumber forUserType:userType weight:weight];
		// sum into the array
		[dayLog setSumFoodNutrientArray:[OmniTool addNutrientArray:dayLog.sumFoodNutrientArray sourceNutrientArray:foodNutrientArray]];
	}
	[OmniTool computeFoodOverview:dayLog];
	return dayLog;
}
// log foods taken at given time
//本週星期幾
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram WeekDay:(WEEK_DAY)weekDay Hour:(int)hour Minute:(int)minute Second:(int)second
{
	if(!foodNumber){
		NSLog(@"Warning! foodNumber is null when calling logFoodTaken: WeightGram: WeekDay: Hour: Minute: Second:");
		return;
	}
	double totalSeconds=hour*3600+minute*60+second;
	// monday 00:00:00 time
	CFAbsoluteTime mondayMorning=[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()];
	CFAbsoluteTime adjustedTime=mondayMorning;
    if (adjustedTime) {
        switch(weekDay){
            case WEEK_DAY_MONDAY:
                adjustedTime= mondayMorning+totalSeconds;
				break;
            case WEEK_DAY_TUESDAY:
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY;
				break;
            case WEEK_DAY_WEDNESDAY:
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY*2;
				break;
            case WEEK_DAY_THURSDAY:
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY*3;
				break;
            case WEEK_DAY_FRIDAY:
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY*4;
				break;
            case WEEK_DAY_SATURDAY:
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY*5;
				break;
            case WEEK_DAY_SUNDAY    :
                adjustedTime= mondayMorning+totalSeconds+SECONDS_IN_ONE_DAY*6;
				break;
        }
        [OmniTool logFoodTaken:foodNumber WeightGram:(double)gram AtTime:adjustedTime];
    }
}

// 底層 API: 新增食物記錄於特定時間
//幾年幾月幾日
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram Year:(int)year Month:(int)month Day:(int)day Hour:(int)hour Minute:(int)minute Second:(double)second
{
	if(!foodNumber){
		NSLog(@"Warning! foodNumber is null when calling logFoodTaken: WeightGram: Year:(int)year Month:(int)month Day:(int)day Hour: Minute: Second:");
		return;
	}
	// compose CFGregorianDate
	CFGregorianDate gDate;
	gDate.year=year;
	gDate.month=month;
	gDate.day=day;
	gDate.hour=hour;
	gDate.minute=minute;
	gDate.second=second;
	if (!CFGregorianDateIsValid(gDate, kCFGregorianAllUnits)){
		NSLog(@"Warning! Illegal date time when calling logFoodTaken: WeightGram:%f Year:%d Month:%d Day:%d Hour:%d Minute:%d Second:%.2f",gram,year,month,day,hour,minute,second);
		return;
	}
    CFTimeZoneRef time = CFTimeZoneCopyDefault();
	CFAbsoluteTime adjustedTime = CFGregorianDateGetAbsoluteTime(gDate, time);
    CFRelease(time);
    [OmniTool logFoodTaken:foodNumber WeightGram:(double)gram AtTime:adjustedTime];
}
// 底層 API: 新增食物記錄於特定時間
//今年幾月幾日
+(void)logFoodTaken:(NSNumber *)foodNumber WeightGram:(double)gram Month:(int)month Day:(int)day Hour:(int)hour Minute:(int)minute Second:(double)second
{
	if(!foodNumber){
		NSLog(@"Warning! foodNumber is null when calling logFoodTaken: WeightGram: Month:(int)month Day:(int)day Hour: Minute: Second:");
		return;
	}
	CFTimeZoneRef currentTimeZone = CFTimeZoneCopyDefault();
	CFGregorianDate cfg=CFAbsoluteTimeGetGregorianDate (
							CFAbsoluteTimeGetCurrent(),
							currentTimeZone
						);
    CFRelease(currentTimeZone);
	[OmniTool logFoodTaken:foodNumber WeightGram:gram Year:cfg.year Month:month Day:day Hour:hour Minute:minute Second:second];

}
/*
底層 API: 清除記錄 
	今日的記錄
*/
+(void) clearFoodTakenLogToday
{

	CFAbsoluteTime todayMorningTime=[OmniTool getMorningTime:CFAbsoluteTimeGetCurrent()];
	CFAbsoluteTime tomorrowMorningTime=todayMorningTime+SECONDS_IN_ONE_DAY;

	[OmniTool clearFoodTakenFrom:todayMorningTime UntilTime:tomorrowMorningTime];
}

// 底層 API: 清除一段時間內的記錄 
+(void) clearFoodTakenFrom:(CFAbsoluteTime)startTime UntilTime:(CFAbsoluteTime) endTime
{
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *updateSql;
		
	if(![db open]){
		NSLog(@"Error in clearFoodTakenFrom: DB [usda.db] open failed");
		return;
	}

	// delete  record
	updateSql = [NSString stringWithFormat:@"DELETE FROM food_taken_log WHERE taken_time >=%f AND taken_time <%f",startTime,endTime];
	[db executeUpdate:updateSql];
	
	[db close];
}
/*
底層 API: 清除記錄 
	本週星期幾的記錄
*/
+(void) clearFoodTakenWeekDay:(WEEK_DAY) weekDay
{
	// monday 00:00:00 time
	CFAbsoluteTime mondayMorning=[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()];
	CFAbsoluteTime adjustedTime=mondayMorning;
    if (adjustedTime) {
        switch(weekDay){
            case WEEK_DAY_MONDAY:
                adjustedTime= mondayMorning;
				break;
            case WEEK_DAY_TUESDAY:
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY;
				break;
            case WEEK_DAY_WEDNESDAY:
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY*2;
				break;
            case WEEK_DAY_THURSDAY:
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY*3;
				break;
            case WEEK_DAY_FRIDAY:
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY*4;
				break;
            case WEEK_DAY_SATURDAY:
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY*5;
				break;
            case WEEK_DAY_SUNDAY    :
                adjustedTime= mondayMorning+SECONDS_IN_ONE_DAY*6;
				break;
        }
        [OmniTool clearFoodTakenFrom:adjustedTime UntilTime:adjustedTime+SECONDS_IN_ONE_DAY];
    }
}

/*
底層 API: 清除記錄 
	本週全部的記錄
*/
+(void) clearFoodTakenThisWeek
{
	CFAbsoluteTime mondayMorningTime=[OmniTool getMondayMorningTime:CFAbsoluteTimeGetCurrent()];

	CFAbsoluteTime nextMondayMorningTime=mondayMorningTime+SECONDS_IN_ONE_DAY*7;

	[OmniTool clearFoodTakenFrom:mondayMorningTime UntilTime:nextMondayMorningTime];
}


+(void) insertWeekTestData
{
		[OmniTool clearFoodTakenLog];	// clear the log for testing
	
	CFAbsoluteTime morningTime=[OmniTool getMondayMorningTime: CFAbsoluteTimeGetCurrent()];
	
	// monday, takes 100g total
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	
	// tuesday, took 200g 
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:30 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:70 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:40 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:60 AtTime:morningTime+31500];
	
	// wednesday, record nothing
	morningTime+=SECONDS_IN_ONE_DAY;
	
	// thursday, took 400g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+11500];
	
	// friday, took 500g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31500];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+500];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:200 AtTime:morningTime+11500];
	
	// saturday, took 600g total
	morningTime+=SECONDS_IN_ONE_DAY;
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:25 AtTime:morningTime+544];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:75 AtTime:morningTime+11521];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:35 AtTime:morningTime+12400];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:65 AtTime:morningTime+31600];
		
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:100 AtTime:morningTime+501];
	[OmniTool logFoodTaken:[[NSNumber alloc] initWithInt:1002] WeightGram:300 AtTime:morningTime+11502];
}


// return a list of FoodTaken object, sorted by time descedning
+(NSMutableArray *) getFoodsTakenToday
{
	CFAbsoluteTime todayMorningTime=[OmniTool getMorningTime:CFAbsoluteTimeGetCurrent()];
	return [OmniTool getFoodsTakenAtDay:todayMorningTime];
}
+(NSMutableArray *) getFoodsTakenAtDay:(CFAbsoluteTime) morningTimeInThatDay
{
	NSMutableArray *array=[[NSMutableArray alloc]init];
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];

	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return array;
	}
	
	/*
		SELECT * FROM food_des,fd_group,food_taken_log,nut_data
		WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd
			AND food_des.ndb_no=food_taken_log.ndb_no
			AND nut_data.ndb_no=food_des.ndb_no
			AND nut_data.nutr_no=(NUTRIENT_ENERGYKCAL)
			AND food_taken_log.taken_time >= (today morning)
			AND food_taken_log.taken_time < (today morning+SECONDS_IN_ONE_DAY)
		ORDER BY food_taken_log.taken_time DESC
	*/
	// NSString *sql=[NSString stringWithFormat:@"SELECT * FROM food_des,fd_group,food_taken_log,nut_data WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND food_des.ndb_no=food_taken_log.ndb_no AND nut_data.ndb_no=food_des.ndb_no AND nut_data.nutr_no=%d AND food_taken_log.taken_time >= %f AND food_taken_log.taken_time < %f ORDER BY food_taken_log.taken_time DESC",NUTRIENT_ENERGYKCAL,morningTimeInThatDay,morningTimeInThatDay+SECONDS_IN_ONE_DAY];
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no ,food_des.long_desc ,food_des.shrt_desc ,fd_group.fdgrp_desc ,fd_group.fdgrp_cd ,food_taken_log.food_weight ,nut_data.nutr_val ,food_taken_log.taken_time FROM food_des,fd_group,food_taken_log,nut_data WHERE fd_group.fdgrp_cd=food_des.fdgrp_cd AND food_des.ndb_no=food_taken_log.ndb_no AND nut_data.ndb_no=food_des.ndb_no AND nut_data.nutr_no=%d AND food_taken_log.taken_time >= %f AND food_taken_log.taken_time < %f ORDER BY food_taken_log.taken_time DESC",NUTRIENT_ENERGYKCAL,morningTimeInThatDay,morningTimeInThatDay+SECONDS_IN_ONE_DAY];
	FMResultSet *rs=[db executeQuery:sql];
	if (!rs)
	{
	    [db close];
	    return array;
	}
	while([rs next]){
		FoodTaken *foodTakenRecord=[FoodTaken alloc];
		Food *f=[Food alloc];
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
//		[f setFactorCarbohydrate:[rs doubleForColumn:@"cho_factor"]];
//		[f setFactorFat:[rs doubleForColumn:@"fat_factor"]];
//		[f setFactorProtein:[rs doubleForColumn:@"pro_factor"]];
//		[f setFactorNitrogen:[rs doubleForColumn:@"n_factor"]];
		[OmniTool seperateTitleSubtitle:f];
		[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
		
		[foodTakenRecord setFood:f];
		[foodTakenRecord setFoodWeightGram:[rs doubleForColumn:@"food_weight"]];
		[foodTakenRecord setFoodCalaries:([rs doubleForColumn:@"nutr_val"]*[rs doubleForColumn:@"food_weight"]/100)];
		[foodTakenRecord setTakeTime:[rs doubleForColumn:@"taken_time"]];
		
		[array addObject:foodTakenRecord];
	}
	[db close];
	return array;
}




//Weekly Average 繪製柱狀圖表動畫。
+(void)weeklyAverageViewController:(float )virtualKey AndBarView:(UIView *)barView AndImageView:(UIImageView *)ImageView{
    
    if (virtualKey < 0.7 && virtualKey > 0.0) {
        barView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:166.0/255.0 blue:24.0/255.0 alpha:1.0];   //橘色
        ImageView.image = [UIImage imageNamed:@"avg_or.png"];
    }else if (virtualKey < 1.3 && virtualKey > 0.7){
        barView.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:201.0/255.0 blue:21.0/255.0 alpha:1.0];   //綠色
        ImageView.image = [UIImage imageNamed:@"avg_green.png"];
    }else if (virtualKey == 0.0){
        ImageView.image = [UIImage imageNamed:@"avg_grey.png"];
    }else{
        barView.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];     //紅色
        ImageView.image = [UIImage imageNamed:@"avg_red.png"];
    }
}
/*
	Ratio: 0----badLowerBound----goodLowerBound----goodUpperBound----badUpperBound
	P2~P3 is good
	P1~P4 is soso
	other is bad
*/
+(void)weeklyAverageViewController:(float )virtualKey 
						AndBarViewColor:(UIView *)barView 
						BadLowerBound:(float)badLowerBound 
						BadUpperBound:(float)badUpperBound 
						GoodLowerBound:(float)goodLowerBound 
						GoodUpperBound:(float)goodUpperBound
{
	if(virtualKey > goodLowerBound && virtualKey < goodUpperBound){
		barView.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:201.0/255.0 blue:21.0/255.0 alpha:1.0];   //綠色
	}else if(virtualKey < badLowerBound || virtualKey > badUpperBound){
		barView.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];     //紅色
	}else{
		barView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:166.0/255.0 blue:24.0/255.0 alpha:1.0];   //橘色
	}
/*
    if (virtualKey < 0.7 && virtualKey > 0.0) {
        barView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:166.0/255.0 blue:24.0/255.0 alpha:1.0];   //橘色
    }else if (virtualKey < 1.3 && virtualKey > 0.7){
        barView.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:201.0/255.0 blue:21.0/255.0 alpha:1.0];   //綠色
    }else if (virtualKey == 0.0){
    }else{
        barView.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];     //紅色
    }
*/
}
+(void)weeklyAverageViewController:(float )virtualKey AndBarViewColor:(UIView *)barView Profile:(int)profile
{
	switch(profile)
	{
		case 0:
		default:	// 100% is best
			[OmniTool weeklyAverageViewController:virtualKey 
						AndBarViewColor:barView 
						BadLowerBound : 0.7
						BadUpperBound : 1.3 
						GoodLowerBound: 0.9 
						GoodUpperBound: 1.1];
			break;
		case 1:	// limit advice
			[OmniTool weeklyAverageViewController:virtualKey 
						AndBarViewColor:barView 
						BadLowerBound : 0
						BadUpperBound : 1.1
						GoodLowerBound: 0 
						GoodUpperBound: 0.9];
			break;
		case 2: // the more the better
			[OmniTool weeklyAverageViewController:virtualKey 
						AndBarViewColor:barView 
						BadLowerBound : 0.7
						BadUpperBound : 99999
						GoodLowerBound: 1
						GoodUpperBound: 9999];
			break;
	}
}
+(void)weeklyAverageViewController:(float )virtualKey AndAnimateBarView:(UIView *)barView{
    if (virtualKey > 1.0) {
        barView.frame = CGRectMake(barView.frame.origin.x, 433-(300*1), 35, 300*1);
    }else{
        barView.frame = CGRectMake(barView.frame.origin.x, 433-(300*virtualKey), 35, 300*virtualKey);
    }
}

+(void)weeklyAverageViewController:(float )virtualKey
                      AndImageView:(UIImageView *)ImageView
                     BadLowerBound:(float)badLowerBound
                     BadUpperBound:(float)badUpperBound
                    GoodLowerBound:(float)goodLowerBound
                    GoodUpperBound:(float)goodUpperBound{
    if (virtualKey > goodLowerBound && virtualKey < goodUpperBound){	// green
		ImageView.image = [UIImage imageNamed:@"avg_green.png"];
	}else if(virtualKey == 0.0){
		ImageView.image = [UIImage imageNamed:@"avg_grey.png"]; // gray, inactive
	}else if(virtualKey < badLowerBound || virtualKey > badUpperBound){
        ImageView.image = [UIImage imageNamed:@"avg_red.png"];
	}else{
		ImageView.image = [UIImage imageNamed:@"avg_or.png"];
	}
}

+(void)weeklyAverageViewController:(float )virtualKey AndImageView:(UIImageView *)ImageView Profile:(int)profile{
    
//    NSLog(@"virtualKey = %f", virtualKey);
    switch(profile)
	{
		case 0:
		default:	// 100% is best
			[OmniTool weeklyAverageViewController:virtualKey
                                  AndImageView:ImageView
                                   BadLowerBound : 0.7
                                   BadUpperBound : 1.3
                                   GoodLowerBound: 0.9
                                   GoodUpperBound: 1.1];
			break;
		case 1:	// limit advice
			[OmniTool weeklyAverageViewController:virtualKey
                                  AndImageView:ImageView
                                   BadLowerBound : 0
                                   BadUpperBound : 1.1
                                   GoodLowerBound: 0
                                   GoodUpperBound: 0.9];
			break;
		case 2: // the more the better
			[OmniTool weeklyAverageViewController:virtualKey 
                                  AndImageView:ImageView 
                                   BadLowerBound : 0.7
                                   BadUpperBound : 99999
                                   GoodLowerBound: 1
                                   GoodUpperBound: 9999];
			break;
	}
}
//今日累積
+(float)todayFatRatio{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    int i;
    float todayFat = 0;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"fat = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] fatRatio]);
        todayFat += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] fatRatio];
    }
    return todayFat;
}
+(float)todaySugarRatio{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    int i;
    float todaySugar = 0;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"sugar = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] sugarRatio]);
        todaySugar += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] sugarRatio];
    }
    return todaySugar;
}
+(float)todaySaltRatio{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    int i;
    float todaySalt = 0;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"salt = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] sodiumRatio]);
        todaySalt += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] sodiumRatio];
    }
    return todaySalt;
}
+(float)todayOtherRatio{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    int i;
    float todayOther = 0;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"other = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] otherRatio]);
        todayOther += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] otherRatio];
    }
    return todayOther;
}
+(float)todayKcalRatio{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    int i;
    float todayKcal = 0;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"Kcal = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] energyRatio]);
        todayKcal += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] energyRatio];
    }
    return todayKcal;
}
+(float)todayKcalVaule{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    float todayKcal = 0;
    int i;
    for (i=0; i<todayAccumulativeArray.count; i++) {
//        NSLog(@"Kcal = %f", [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] energyRatio]*2600);
        todayKcal += [[OmniTool getFoodOverview:[[[todayAccumulativeArray objectAtIndex:i] food] foodNumber] forUserType:1 weight:[[todayAccumulativeArray objectAtIndex:i] foodWeightGram]] energyRatio]*2600;
    }
    return todayKcal;
}

+(BOOL)todayAlreadyTaken{
    todayAccumulativeArray = [OmniTool getFoodsTakenToday];
    if([todayAccumulativeArray count] >0)
    	return YES;
    else
    	return NO;
}

//首頁色塊方塊繪圖
+(void)colorBoxWithRatio:(float)Ratio
		AndTodayRatio:(float)TodayRatio
		AndInforgraphicView:(UIView *)inforgraphicView
		AndAddInforGraphicView:(UIView *)addInforgraphicView
		AndVauleLabel:(UILabel *)VauleLabel
		AndColorButton:(UIButton *)colorButton
		AndPoint:(CGPoint)Point
		AndSize:(CGSize)Size
		DoDebug:(BOOL)doDebug
{
    float bottomRatio=ZERO_BOTTOMLINE_HEIGHT / Size.height;
    //	if(doDebug)
    //		NSLog(@"colorBoxWithRatio:%f",Ratio+TodayRatio);
    VauleLabel.text = [NSString stringWithFormat:@"+ %.0f%%",Ratio*100];
    if ((Ratio+TodayRatio) < bottomRatio) {
    	[OmniTool setButtonColor:colorButton Color:GREEN_TEXT_COLOR Debug:doDebug];
        VauleLabel.textColor 			 = GREEN_TEXT_COLOR;
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-ZERO_BOTTOMLINE_HEIGHT, Size.width, ZERO_BOTTOMLINE_HEIGHT);
        inforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-ZERO_BOTTOMLINE_HEIGHT, Size.width, ZERO_BOTTOMLINE_HEIGHT);
    }else if ((Ratio+TodayRatio) < 0.5) {
    	[OmniTool setButtonColor:colorButton Color:GREEN_TEXT_COLOR Debug:doDebug];
        VauleLabel.textColor = GREEN_TEXT_COLOR;
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*(Ratio+TodayRatio)), Size.width, Size.height*(Ratio+TodayRatio));
    }else if ((Ratio+TodayRatio) > 0.5 && (Ratio+TodayRatio) < 1){
    	[OmniTool setButtonColor:colorButton Color:[UIColor whiteColor] Debug:doDebug];
        VauleLabel.textColor = [UIColor whiteColor];
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*(Ratio+TodayRatio)), Size.width, Size.height*(Ratio+TodayRatio));
    }else{
    	[OmniTool setButtonColor:colorButton Color:[UIColor whiteColor] Debug:doDebug];
        VauleLabel.textColor = [UIColor whiteColor];
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*1), Size.width, Size.height*1);
    }
}
//Calories色塊方塊繪圖
+(void)energyColorBoxWithValue:(float)value
                CurrentRatio:(float)Ratio
           AndTodayRatio:(float)TodayRatio
     AndInforgraphicView:(UIView *)inforgraphicView
  AndAddInforGraphicView:(UIView *)addInforgraphicView
           AndVauleLabel:(UILabel *)VauleLabel
          AndColorButton:(UIButton *)colorButton
                AndPoint:(CGPoint)Point
                 AndSize:(CGSize)Size
                 DoDebug:(BOOL)doDebug
{
    float bottomRatio=ZERO_BOTTOMLINE_HEIGHT / Size.height;
    //	if(doDebug)
    //		NSLog(@"colorBoxWithRatio:%f",Ratio+TodayRatio);
    VauleLabel.text = [NSString stringWithFormat:@"+ %.0f",value];
    if ((Ratio+TodayRatio) < bottomRatio) {
    	[OmniTool setButtonColor:colorButton Color:GREEN_TEXT_COLOR Debug:doDebug];
        VauleLabel.textColor 			 = GREEN_TEXT_COLOR;
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-ZERO_BOTTOMLINE_HEIGHT, Size.width, ZERO_BOTTOMLINE_HEIGHT);
        inforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-ZERO_BOTTOMLINE_HEIGHT, Size.width, ZERO_BOTTOMLINE_HEIGHT);
    }else if ((Ratio+TodayRatio) < 0.5) {
    	[OmniTool setButtonColor:colorButton Color:GREEN_TEXT_COLOR Debug:doDebug];
        VauleLabel.textColor = GREEN_TEXT_COLOR;
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*(Ratio+TodayRatio)), Size.width, Size.height*(Ratio+TodayRatio));
    }else if ((Ratio+TodayRatio) > 0.5 && (Ratio+TodayRatio) < 1){
    	[OmniTool setButtonColor:colorButton Color:[UIColor whiteColor] Debug:doDebug];
        VauleLabel.textColor = [UIColor whiteColor];
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*(Ratio+TodayRatio)), Size.width, Size.height*(Ratio+TodayRatio));
    }else{
    	[OmniTool setButtonColor:colorButton Color:[UIColor whiteColor] Debug:doDebug];
        VauleLabel.textColor = [UIColor whiteColor];
        addInforgraphicView.frame = CGRectMake(Point.x, Point.y+Size.height-(Size.height*1), Size.width, Size.height*1);
    }
}
/*
+(void)energyRatioColorBoxWithRatio:(float)Ratio AndTodayRatio:(float)TodayRatio AndEnergyKcal:(float)EnergyValue AndInforgraphicView:(UIView *)inforgraphicView AndAddInforGraphicView:(UIView *)addInforgraphicView AndTriangleImage:(UIImageView *)triangleImage AndVauleLabel:(UILabel *)VauleLabel AndColorButton:(UIButton *)colorButton AndPoint:(CGPoint)Point AndSize:(CGSize)Size AndTrianglePoint:(CGPoint)triPoint AndTriangleSize:(CGSize)triSize{
    VauleLabel.text = [NSString stringWithFormat:@"%.0f",EnergyValue];
}
 */
+(void)theRuleForColorBoxWithRatio:(float)TodayRatio AndVirtualGraphic:(UIView *)VirtualGraphic andPointX:(float)PointX AndPointY:(float)PointY AndSizeWidth:(float)width AndSizeHeight:(float)height{
    if (TodayRatio < ZERO_BOTTOMLINE_HEIGHT/height) {
        VirtualGraphic.frame = CGRectMake(PointX, PointY-ZERO_BOTTOMLINE_HEIGHT, width, ZERO_BOTTOMLINE_HEIGHT);
    }else if (TodayRatio > 1.0){
        VirtualGraphic.frame = CGRectMake(PointX, PointY-(height*1.0), width, height*1.0);
    }else{
        VirtualGraphic.frame = CGRectMake(PointX, PointY-(height*self.todayFatRatio), width, height*self.todayFatRatio);
    }
}

+(void)theRuleForKcalColorBoxWithRatio:(float)TodayRatio AndVirtualGraphic:(UIView *)VirtualGraphic andPointX:(float)PointX AndPointY:(float)PointY AndSizeWidth:(float)width AndSizeHeight:(float)height AndTriangleImage:(UIImageView *)triangleImage AndTrianglePointX:(float)triangleImagePointX AndTrianglePointY:(float)triangleImagePointY AndTriangleSizeWidth:(float)triangleImageWidth AndTriangleSizeHeight:(float)triangleImageHeight{
    if (TodayRatio < ZERO_BOTTOMLINE_HEIGHT/height) {
        VirtualGraphic.frame = CGRectMake(PointX, PointY-ZERO_BOTTOMLINE_HEIGHT, width, ZERO_BOTTOMLINE_HEIGHT);
        triangleImage.frame = CGRectMake(triangleImagePointX, triangleImagePointY-ZERO_BOTTOMLINE_HEIGHT, triangleImageWidth, triangleImageHeight);
    }else if (TodayRatio > 1.0){
        VirtualGraphic.frame = CGRectMake(PointX, PointY-(height*1.0), width, height*1.0);
        triangleImage.frame = CGRectMake(triangleImagePointX, triangleImagePointY-(height*1.0), triangleImageWidth, triangleImageHeight);
    }else{
        VirtualGraphic.frame = CGRectMake(PointX, PointY-(height*self.todayKcalRatio), width, height*self.todayKcalRatio);
        triangleImage.frame = CGRectMake(triangleImagePointX, triangleImagePointY-(height*self.todayKcalRatio), triangleImageWidth, triangleImageHeight);
    }
}
/*
//繪製update()有今日累積食物
+(void)DrawWithTodayRatio:(float)todayRatio AndVirtualGraphic:(UIView *)VirtualGraphic AndPointX:(float)PointX AndPointY:(float)PointY AndWidth:(float)width AndHeight:(float)height AndAddVirtualGraphic:(UIView *)addVirtualGraphic{
    //先分成有連磅秤狀態，沒有連結磅秤狀態。
    if ([(SRAppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected]) {
        //連結磅秤的情況。
        if (todayRatio < ZERO_BOTTOMLINE_HEIGHT/height) {
            VirtualGraphic.frame = CGRectMake(PointX, PointY+height-ZERO_BOTTOMLINE_HEIGHT, width, ZERO_BOTTOMLINE_HEIGHT);
        }else if (todayRatio > 1.0){
            VirtualGraphic.frame = CGRectMake(PointX, PointY+height-(height*1.0), width, height*1.0);
        }else{
            VirtualGraphic.frame = CGRectMake(PointX, PointY+height-(height*todayRatio), width, height*todayRatio);
        }
    }else{
        //沒有連結磅秤情況。
        if (todayRatio < ZERO_BOTTOMLINE_HEIGHT/height) {
            VirtualGraphic.frame = addVirtualGraphic.frame = CGRectMake(PointX, PointY+height-ZERO_BOTTOMLINE_HEIGHT, width, ZERO_BOTTOMLINE_HEIGHT);
        }else if (todayRatio > 1.0){
            VirtualGraphic.frame = addVirtualGraphic.frame = CGRectMake(PointX, PointY+height-(height*1.0), width, height*1.0);
        }else{
            VirtualGraphic.frame = addVirtualGraphic.frame = CGRectMake(PointX, PointY+height-(height*todayRatio), width, height*todayRatio);
        }
    }
}
*/

//初始化色塊
+(void)initColorBoxName:(NSString *)titleName AndInforgraphicView:(UIView *)inforgraphicView AndeBGView:(UIView *)BackGroundView AndBGPoint:(CGPoint)BGPoint AndBGSize:(CGSize)BGSize AndVirtualGraphic:(UIView *)virtualGraphic AndPoint:(CGPoint)Point AndSize:(CGSize)Size BackGroundImageView:(UIImageView *)BGImageView AndAddVirtualGraphic:(UIView *)addVirtualGraphic AndBGColor:(UIColor *)BGColor AndLightColor:(UIColor *)lightColor AndVauleLabel:(UILabel *)VauleLabel AndVLPoint:(CGPoint)VLPoint AndVLSize:(CGSize)VLSize AndButton:(UIButton *)Button{
    BackGroundView.backgroundColor = [UIColor clearColor];
    
    BGImageView.image = [UIImage imageNamed:@"p2a-show-date.png"];
    BGImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:BGImageView];
    
    addVirtualGraphic.backgroundColor = lightColor;
    addVirtualGraphic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:addVirtualGraphic];
    
    virtualGraphic.backgroundColor = BGColor;
    virtualGraphic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:virtualGraphic];
    
    [VauleLabel setText:@"100%"];
    [VauleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [VauleLabel setTextColor:[UIColor whiteColor]];
    [VauleLabel setBackgroundColor:[UIColor clearColor]];
    [VauleLabel setTextAlignment:NSTextAlignmentCenter];
    VauleLabel.frame = CGRectMake(VLPoint.x, VLPoint.y, 180, 45);
    VauleLabel.autoresizingMask = UIViewAutoresizingNone;
    [BackGroundView addSubview:VauleLabel];
    
    [Button setBackgroundColor:[UIColor clearColor]];
    [Button setTitle:titleName forState:UIControlStateNormal];
    [Button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [Button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    Button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [BackGroundView addSubview:Button];
    [inforgraphicView addSubview:BackGroundView];
}
//初始化卡路里色塊
+(void)initCalorieBoxName:(NSString *)titleName
      AndInforgraphicView:(UIView *)inforgraphicView
               AndeBGView:(UIView *)BackGroundView
               AndBGPoint:(CGPoint)BGPoint
                AndBGSize:(CGSize)BGSize
        AndVirtualGraphic:(UIView *)virtualGraphic
                 AndPoint:(CGPoint)Point
                  AndSize:(CGSize)Size
       AdnTrigleImageView:(UIImageView *)triangleImageView
         AndTrianglePoint:(CGPoint)TPoint
          AndTriangleSize:(CGSize)TSize
      BackGroundImageView:(UIImageView *)BGImageView
     AndAddVirtualGraphic:(UIView *)addVirtualGraphic
       AndAddTriangleView:(UIImageView *)addTriangleImageView
      AndAddTrianglePoint:(CGPoint)ATPoint
       AndAddTriangleSize:(CGSize)ATSize
               AndBGColor:(UIColor *)BGColor
            AndLightColor:(UIColor *)lightColor
            AndVauleLabel:(UILabel *)VauleLabel
               AndVLPoint:(CGPoint)VLPoint
                AndVLSize:(CGSize)VLSize
                AndButton:(UIButton *)Button
{

    BackGroundView.backgroundColor = [UIColor clearColor];
    
    BGImageView.image = [UIImage imageNamed:@"kcal.png"];
    BGImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:BGImageView];
    
    addVirtualGraphic.backgroundColor = lightColor;
    addVirtualGraphic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:addVirtualGraphic];
    
    addTriangleImageView.image = [UIImage imageNamed:@"addTriangle.png"];
    addTriangleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:addTriangleImageView];
    
    virtualGraphic.backgroundColor = BGColor;
    virtualGraphic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [BackGroundView addSubview:virtualGraphic];
    
    triangleImageView.image = [UIImage imageNamed:@"triangle.png"];
    triangleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    triangleImageView.frame=CGRectMake(TPoint.x, TPoint.y, TSize.width, TSize.height);
    [BackGroundView addSubview:triangleImageView];
    
    [VauleLabel setText:@"100"];
    [VauleLabel setFont:[UIFont boldSystemFontOfSize:38.0f]];
    [VauleLabel setTextColor:[UIColor whiteColor]];
    [VauleLabel setBackgroundColor:[UIColor clearColor]];
    [VauleLabel setTextAlignment:NSTextAlignmentCenter];
    VauleLabel.frame = CGRectMake(VLPoint.x, VLPoint.y, 180, 45);
    VauleLabel.autoresizingMask = UIViewAutoresizingNone;
    [BackGroundView addSubview:VauleLabel];
    
    [Button setBackgroundColor:[UIColor clearColor]];
    [Button setTitle:titleName forState:UIControlStateNormal];
//    [Button.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:38]];
    [Button.titleLabel.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:38]}];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button.titleLabel setFont:[UIFont boldSystemFontOfSize:38]];
    [Button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    Button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [BackGroundView addSubview:Button];
    [inforgraphicView addSubview:BackGroundView];
}
+(void) landscapeBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog
{
	[OmniTool orientationBoxFixTitleColor:totalRatio VirtualGraphic:virtualGraphic Button:boxButton Label:boxLabel DebugLog:doLog CritilHeight:171.0f];
}
+(void) portraitBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog
{
	[OmniTool orientationBoxFixTitleColor:totalRatio VirtualGraphic:virtualGraphic Button:boxButton Label:boxLabel DebugLog:doLog CritilHeight:238.0f];
}
+(void) orientationBoxFixTitleColor:(double)totalRatio VirtualGraphic:(UIView *)virtualGraphic Button:(UIButton*)boxButton Label:(UILabel *)boxLabel DebugLog:(BOOL)doLog CritilHeight:(float)criticalHeight
{
	UIColor *textColor;
	UIColor *labelColor;
	// BOOL connected=[(AppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected];
    BOOL connected = [OmniTool existWeightInput];
    if (totalRatio == 0 && virtualGraphic.frame.size.height > criticalHeight) {
        textColor = [UIColor whiteColor];
        if(connected){
        	labelColor=[UIColor whiteColor];
        }else{
        	labelColor=[UIColor clearColor];
        }
    }else{
        //先判斷有無聯結磅秤
        if (connected) {
            if (totalRatio > 0.5) {
                textColor = [UIColor whiteColor];
	        	labelColor=[UIColor whiteColor];
            }else if (totalRatio == 0 && virtualGraphic.frame.size.height > criticalHeight){
                textColor = GREEN_TEXT_COLOR;
	        	labelColor=GREEN_TEXT_COLOR;
            }else{
                textColor = GREEN_TEXT_COLOR;
	        	labelColor=GREEN_TEXT_COLOR;
            }
        }else{
            // not connected
            //
            if (totalRatio > 0.5) {
                textColor = [UIColor whiteColor];
                labelColor=[UIColor whiteColor];
            }else if (totalRatio == 0 && virtualGraphic.frame.size.height > criticalHeight){
                textColor = [UIColor whiteColor];
                labelColor=[UIColor clearColor];
            }else{
                textColor = GREEN_TEXT_COLOR;
                labelColor=GREEN_TEXT_COLOR;
            }
        }
    }
	if(doLog)
	{
		if(![boxButton.titleLabel.textColor isEqual:textColor] || ![boxLabel.textColor isEqual:labelColor])
		{
			NSLog(@"orientationBoxFixTitleColor:ratio=%f, textColor => %@, labelColor =>  %@",totalRatio,textColor,labelColor);
		}
		
	}
    [boxButton setTitleColor:textColor forState:UIControlStateNormal];
    boxLabel.textColor=labelColor;
}



/*
	底層 API: 某一日食物List (食物，重量，卡路里)
	return a list of FoodTaken object, sorted by time descedning
*/
+(NSMutableArray *) getFoodsTakenAtDate:(int)year Month:(int)month Day:(int)day
{
	int hour=0;
	int minute=0;
	double second=0;
	// compose CFGregorianDate
	CFGregorianDate gDate;
	gDate.year=year;
	gDate.month=month;
	gDate.day=day;
	gDate.hour=hour;
	gDate.minute=minute;
	gDate.second=second;
	if (!CFGregorianDateIsValid(gDate, kCFGregorianAllUnits)){
		NSLog(@"Warning! Illegal date time when calling getFoodsTakenAtDate:  Year:%d Month:%d Day:%d Hour:%d Minute:%d Second:%.2f",year,month,day,hour,minute,second);
	}
    
    CFTimeZoneRef time = CFTimeZoneCopyDefault();
	CFAbsoluteTime adjustedTime = CFGregorianDateGetAbsoluteTime(gDate, time);
    CFRelease(time);
    return [OmniTool getFoodsTakenAtDay: adjustedTime];
}

/*
	底層 API: 刪除某一筆攝取記錄
*/
+(void)	deleteFoodTake:(FoodTaken *)foodTakeRecord
{
	if(!foodTakeRecord)
	{
		NSLog(@"Error! deleteFoodTake:nil");
		return;
	}
    
	if(![[foodTakeRecord food] foodNumber])
	{
		NSLog(@"Error! deleteFoodTake:foodNumber=nil");
		return;
	}
	
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	NSString *updateSql;
	
	if(![db open]){
		NSLog(@"DB [usda.db] open failed");
		return;
	}
	
	// delete  record
	updateSql = [NSString stringWithFormat:@"DELETE FROM food_taken_log WHERE ndb_no=%d AND food_weight=%f AND taken_time=%f",[[[foodTakeRecord food] foodNumber] intValue],[foodTakeRecord foodWeightGram],[foodTakeRecord takeTime]];
	[db executeUpdate:updateSql];
	
	[db close];
}
+(void) setButtonColor:(UIButton*)boxButton Color:(UIColor *)color Debug:(BOOL)doDebug
{
	if(doDebug){
		if(![boxButton.titleLabel.textColor isEqual:color])
			NSLog(@"TextColor %@ => %@",boxButton.titleLabel.textColor,color);
		// if(![boxButton.titleLabel.highlightedTextColor isEqual:color])
		// 	NSLog(@"Change highlightedTextColor %@  ->  %@",boxButton.titleLabel.highlightedTextColor,color);
	}
    [boxButton setTitleColor:color forState:UIControlStateNormal];
    // [boxButton setTitleColor:color forState:UIControlStateHighlighted];
}
/*
+(BOOL) isScaleConnected
{
	return [(SRAppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected];
}
*/
+(BOOL) isScaleConnected
{
	return [(AppDelegate *)[[UIApplication sharedApplication] delegate] isPeripheralConnected];
}


// either manual input, or connected to scale. There's a weight can use
+(BOOL) existWeightInput
{
    if (isInputWeightView) {
        return YES;
    }else{
		return [OmniTool isScaleConnected];
    }
}

+(void) checkUIViewFrame:(UIView *)view Tag:(NSString *)tag
{
	NSLog(@"%@ frame=(%.1f,%.1f) - (%.1f,%.1f)",
          tag,
          CGRectGetMinX(view.frame),
          CGRectGetMinY(view.frame),
          CGRectGetMaxX(view.frame),
          CGRectGetMaxY(view.frame));
}

+(CGRect) frameShift:(CGRect)rect Y:(int) shiftY
{
	rect.origin.y+=shiftY;
	return rect;
}

+(void) loadCertifiedBLENames
{
	if(!certifiedDeviceNameDictionary)
	{
		certifiedDeviceNameDictionary=[[NSMutableDictionary alloc] init];
	}
	[certifiedDeviceNameDictionary setObject:@"INFOS 2093v35.05" forKey:@"INFOS 2093v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 9A3Bv35.05" forKey:@"INFOS 9A3Bv35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 9A74v35.05" forKey:@"INFOS 9A74v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 2091v35.05" forKey:@"INFOS 2091v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 9A47v35.05" forKey:@"INFOS 9A47v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 2094v35.05" forKey:@"INFOS 2094v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 24C7v35.05" forKey:@"INFOS 24C7v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 2472v35.05" forKey:@"INFOS 2472v35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 244Dv35.05" forKey:@"INFOS 244Dv35.05"];
	[certifiedDeviceNameDictionary setObject:@"INFOS 24B7v35.05" forKey:@"INFOS 24B7v35.05"];

}
+(UIInterfaceOrientation) getCurrentOrientation
{
    UIDeviceOrientation deviceOrientation=[[UIDevice currentDevice] orientation];
    switch(deviceOrientation)
    {
		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
        default:
            return [UIApplication sharedApplication].statusBarOrientation;
            break;
		case UIDeviceOrientationPortrait:
            return UIInterfaceOrientationPortrait;
		case UIDeviceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationPortraitUpsideDown;
		case UIDeviceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
		case UIDeviceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
            break;
    }
}
//	triangleImage.frame 應該設為 kcalVirtualGraphic.x, kcalVirtualGraphic.y-triangleImage.height
+(void) adjustTriangleImage:(UIImageView*) triangleImage ReferenceFrame:(CGRect)refFrame
{
    
    //	NSLog(@"adjustTriangleImage frame=(%.1f,%.1f) - (%.1f,%.1f)",
    //		CGRectGetMinX(refFrame),
    //		CGRectGetMinY(refFrame),
    //		CGRectGetMaxX(refFrame),
    //		CGRectGetMaxY(refFrame));
    
	CGRect myCGRect=CGRectMake(refFrame.origin.x,
                               refFrame.origin.y-triangleImage.frame.size.height+2,
                               refFrame.size.width, triangleImage.frame.size.height);
    
    //	NSLog(@"adjustTriangleImage mid =(%.1f,%.1f) - (%.1f,%.1f)",
    //		CGRectGetMinX(myCGRect),
    //		CGRectGetMinY(myCGRect),
    //		CGRectGetMaxX(myCGRect),
    //		CGRectGetMaxY(myCGRect));
    
	triangleImage.frame=myCGRect;
    
    //	NSLog(@"adjustTriangleImage after =(%.1f,%.1f) - (%.1f,%.1f)",
    //		CGRectGetMinX(triangleImage.frame),
    //		CGRectGetMinY(triangleImage.frame),
    //		CGRectGetMaxX(triangleImage.frame),
    //		CGRectGetMaxY(triangleImage.frame));
    
}

+ (UIImage *) imageWithViewBackground:(UIView *)view{
    CGSize size = CGSizeMake(295.0f, 372.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);    // NO 背景透明。
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    
    UIView *setView = [[UIView alloc] initWithFrame:CGRectMake(view.bounds.origin.x, 0, view.bounds.size.width, view.bounds.size.height)];
    
    CGContextFillRect(ctx, setView.bounds);
    
    [view setOpaque:NO];
    [view.layer setOpaque:NO];
    [view setBackgroundColor:[UIColor clearColor]];
    [view.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [view.layer renderInContext:ctx];
    
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    
    return image1;
}

// 將所有的View 截圖變成image。
+ (UIImage *) imageWithView:(UIView *)view{
    CGSize size = CGSizeMake(640.0f, 640.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);    // NO 背景透明。
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    
    UIView *setView = [[UIView alloc] initWithFrame:CGRectMake(view.bounds.origin.x, 0, view.bounds.size.width, view.bounds.size.height)];
    
    CGContextFillRect(ctx, setView.bounds);
    
    [view setOpaque:NO];
    [view.layer setOpaque:NO];
    [view setBackgroundColor:[UIColor clearColor]];
    [view.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [view.layer renderInContext:ctx];
    
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    
    return image1;
}

+(void)addNutrientOverview:(NutrientOverview *)targetOverview FromFoodOverview:(FoodOverview *)sourceOverview
{
	if(!targetOverview.nutrientDictionary)
		targetOverview.nutrientDictionary=[[NSMutableDictionary alloc]init];
	
	for(FoodNutrient *foodNutrient in sourceOverview.rdaFoodNutrientArray)
	{
		Nutrient *nutrient=[targetOverview.nutrientDictionary objectForKey:[foodNutrient nutrientNumber]];
		if(!nutrient)
		{
			nutrient=[foodNutrient toNutrient];
			[targetOverview.nutrientDictionary setObject:nutrient forKey:[nutrient nutrientNumber]];
		}else{
			[nutrient setNutrientValue:(nutrient.nutrientValue + foodNutrient.nutrientValue)];
			[nutrient setRdaRatio:(nutrient.rdaRatio+foodNutrient.rdaRatio)];
		}
	}
}
+(void) initialCurrentMeal
{
    __currentMeal=[[Meal alloc] initialize];
}
+(Meal *) getCurrentMeal
{    if(!__currentMeal)
        [OmniTool initialCurrentMeal];
    return __currentMeal;
}
+(void) printInfoNSData:(NSData*) data
{
	char * bytes=(char *)[data bytes];
	for(int i=0;i<[data length];i++){
		printf("%d\t",(unsigned char)bytes[i]);
	}
	printf("\r\n");
}
+(Food *)getFoodWithNumber:(unsigned int)foodNumber
{
	NSString *dbPath=[OmniTool getDatabasePath:@"usda.db"];
	FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
	Food *f=[Food alloc];
    
	if(![db open]){
		NSLog(@"DB [usda.db]open failed");
		return nil;
	}
	/*
     SELECT food_des.ndb_no, food_des.long_desc, food_des.shrt_desc, fd_group.fdgrp_desc, fd_group.fdgrp_cd
     FROM food_des,fd_group
     WHERE food_des.ndb_no = %d
     AND food_des.fdgrp_cd=fd_group.fdgrp_cd
     */
	NSString *sql=[NSString stringWithFormat:@"SELECT food_des.ndb_no, food_des.long_desc, food_des.shrt_desc, fd_group.fdgrp_desc, fd_group.fdgrp_cd FROM food_des,fd_group WHERE food_des.ndb_no=%d AND food_des.fdgrp_cd=fd_group.fdgrp_cd ",foodNumber];
	FMResultSet *rs=[db executeQuery:sql];
	if([rs next]){
		[f setFoodNumberWithInt:[rs intForColumn:@"ndb_no"]];
		[f setLongDescription:[rs stringForColumn:@"long_desc"]];
		[f setShortDescription:[rs stringForColumn:@"shrt_desc"]];
		[f setFoodGroup:[rs stringForColumn:@"fdgrp_desc"]];
		[OmniTool seperateTitleSubtitle:f];
		[f setFoodImageWithGroupID:[rs intForColumn:@"fdgrp_cd"]];
	}
    
	[db close];
	return f;
}



+(void) initialHardcodedMeals
{
	CapreseSalad = [[Meal alloc] initialize];
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:1026] withWeight:40]]; //120 g	 Cheese, mozzarella, whole milk	1026
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11529] withWeight:150]]; //150 g	 Tomatoes, red, ripe, raw, year round average	11529
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2044] withWeight:50]]; //50 g	 Basil, fresh	2044
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2054] withWeight:15]]; //15 g	 Capers, canned	2054
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:4053] withWeight:30]]; //30 g	 Oil, olive, salad or cookin g	4053
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2069] withWeight:12]]; //12 g	 Vinegar, balsamic	2069
//	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2047] withWeight:1]]; //1 g	Salt, table 	2047
	[CapreseSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2030] withWeight:1]]; //1 g	Spices, pepper, black	2030
	
	TomatoSpaghetti = [[Meal alloc] initialize];
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11693] withWeight:40]]; //40 g	Tomatoes, crushed, canned	11693
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11286] withWeight:80]]; //80 g	Onion, yellow, sauteed	11286
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2047] withWeight:0.5]]; //1 g	Salt, table 	2047
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2030] withWeight:1]]; //1 g	Spices, pepper, black	2030
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11215] withWeight:10]]; //10 g	Garlic, raw	11215
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11819] withWeight:5]]; //5 g	Peppers, hot chili, red, raw	11819
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2044] withWeight:2]]; //2 g	Basil, fresh 	2044
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:20120] withWeight:100]]; //125 g	Spaghetti, dry, enriched	20120
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:4053] withWeight:15]]; //15 g	Oil, olive, salad or cookin g	4053
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11529] withWeight:100]]; //100 g	Tomatoes, red, ripe, raw, year round average	11529
	[TomatoSpaghetti addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:1032] withWeight:30]]; //30 g	Cheese, parmesan, grated	1032 //
    
	FreshBerriesIceCream = [[Meal alloc] initialize];
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:9050] withWeight:150]]; //150 g	Blueberries, raw	9050
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:9042] withWeight:150]]; //150 g	Blackberries, raw	9042
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:14411] withWeight:150]]; //150 g	Water	14411
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:19334] withWeight:20]]; //50 g	Sugar, brown	19334
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:9152] withWeight:15]]; //20 g	Lemon juice,raw	9152
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:1077] withWeight:150]]; //250 g	Milk, whole, 3.25% milkfat, with added vitaminD	1077
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:1053] withWeight:100]]; //150 g	Cream, fluid, heavy whippin g	1053
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:1125] withWeight:30]]; //40 g	Egg, yolks, raw, fresh	1125
	[FreshBerriesIceCream addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2050] withWeight:5]]; //5 g	Vanilla, extract	2050
    
	ChickenVegetablesSalad = [[Meal alloc] initialize];
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11216] withWeight:2]]; //2 g	Ginger root, raw	11216
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:4058] withWeight:4]]; //4 g	Oil, sesame, salad or cookin g	4058
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11251] withWeight:100]]; //100 g	Lettuce, cos or  romaine, raw	11251
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:16085] withWeight:30]]; //30 g	Peas, split, mature seeds, raw	16085
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11165] withWeight:30]]; //30 g	Coriander(cilantro) leaves, raw	11165
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:12087] withWeight:20]]; //20 g	Nuts, cashews nuts, raw	12087
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:9004] withWeight:25]]; //25 g	Apple, raw, without skin	9004
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11143] withWeight:15]]; //15 g	Celery, raw	11143
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:11282] withWeight:15]]; //15 g	Onions, raw	11282
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:12154] withWeight:10]]; //10 g	Nuts, walnuts, black, dried	12154
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2069] withWeight:5]]; //5 g	Vinegar, balsamic	2069
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:4053] withWeight:10]]; //10 g	Oil, olive, salad or cookin g	4053
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2047] withWeight:0.5]]; //1 g	Salt, table 	2047
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2030] withWeight:1]]; //1 g	Spices, pepper, black	2030
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:5013] withWeight:100]]; //120 g	Chicken, broilers or fryers, meat only, roasted	5013
	[ChickenVegetablesSalad addIngredient:[[Ingredient alloc] initializeWithFood:[OmniTool getFoodWithNumber:2046] withWeight:2]]; //2 g	Mustard, prepared, yellow	2046
}

+(void) addMinnaListener:(id<MinnaNotificationProtocol>) listener
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] addMinnaListener:listener];
}
+(void) broadcastMinnaMessage:(NSString *)broadcastMessage
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] broadcastMinnaNotificationMessage:broadcastMessage];
}
+(NSString *) CStringToNSString:(char *) cString ReplaceCRLF:(BOOL) replaceCRLF
{
	NSString *myNSString = [NSString stringWithUTF8String:cString];
	if(replaceCRLF){
		myNSString = [myNSString stringByReplacingOccurrencesOfString:@"\r" withString:@"<CR>"];
		myNSString = [myNSString stringByReplacingOccurrencesOfString:@"\n" withString:@"<LF>"];
	}
	return myNSString;
}

/*
 2013-10-01 16:08:50.773 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] ********** CapreseSalad **********
 2013-10-01 16:08:50.775 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] **** Meal Info ****
 2013-10-01 16:08:50.776 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=2044, weight=50, description=Basil, fresh
 2013-10-01 16:08:50.777 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=2030, weight=1, description=Spices, pepper, black
 2013-10-01 16:08:50.777 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=2054, weight=15, description=Capers, canned
 2013-10-01 16:08:50.778 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=2047, weight=1, description=Salt, table
 2013-10-01 16:08:50.779 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=2069, weight=12, description=Vinegar, balsamic
 2013-10-01 16:08:50.779 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=4053, weight=30, description=Oil, olive, salad or cooking
 2013-10-01 16:08:50.780 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=11529, weight=150, description=Tomatoes, red, ripe, raw, year round average
 2013-10-01 16:08:50.780 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] .Ingredient number=1026, weight=120, description=Cheese, mozzarella, whole milk
 2013-10-01 16:08:50.930 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] --SUGAR nutrient--
 2013-10-01 16:08:50.931 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] Nutrient(Sugars, total): Number=269, value=7.192900 g, RDA ratio=0.200
 2013-10-01 16:08:50.932 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] --Sodium nutrient--
 2013-10-01 16:08:50.932 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] Nutrient(Sodium, Na): Number=307, value=1568.390000 mg, RDA ratio=1.046
 2013-10-01 16:08:50.933 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] --Fat nutrient--
 2013-10-01 16:08:50.933 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] Nutrient(Total lipid (fat)): Number=204, value=57.601600 g, RDA ratio=0.081
 2013-10-01 16:08:50.934 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] --Kcal nutrient--
 2013-10-01 16:08:50.935 iPhoneNutritionScaleForIOS7WithStoryBoard[963:60b] Nutrient(Energy): Number=208, value=680.220000 kcal, RDA ratio=0.262
 */
+(void) testCodes
{
    [OmniTool initialHardcodedMeals];
    
    NSLog(@"test atof:=%f",atof("-   75.0"));

}
@end
