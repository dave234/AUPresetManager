//
//  AUPresetManager.h
//
//  Created by David O'Neill on 1/8/17.
//  Copyright © 2017 David O'Neill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUPresetZone : NSObject
@property BOOL      enabled;
@property BOOL      loopEnabled;
@property BOOL      pitchTracking;
@property int       maxKey;
@property int       minKey;
@property int       rootKey;
@property NSString *filePath;
/*
 Initializes to a non pitch tracking sample (ie: for drums)
 All samples refered to by filePath must be in a "Sounds" Folder Reference (Not Xcode group) located in the Application bundle 
*/
-(instancetype)initWithFilePath:(NSString *)filePath andKey:(int)key;
+(AUPresetZone *)WithFilePath:(NSString *)filePath andKey:(int)key;
@end

@interface AUPresetManager : NSObject
+(NSDictionary *)presetWithZones:(NSArray <AUPresetZone *> *)presetZones oneShot:(BOOL)oneShot;
@end
