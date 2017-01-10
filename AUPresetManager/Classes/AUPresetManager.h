//
//  AUPresetManager.h
//
//  Created by David O'Neill on 1/8/17.
//  Copyright © 2017 David O'Neill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AUPresetZone : NSObject
@property BOOL      enabled;
@property BOOL      loopEnabled;
@property BOOL      pitchTracking;
@property int       maxKey;
@property int       minKey;
@property int       rootKey;
@property NSString *filePath;

//Initializes to a non pitch tracking sample (ie: for drums)
-(instancetype)initWithFilePath:(NSString *)filePath andKey:(int)key;
+(AUPresetZone *)zoneWithFilePath:(NSString *)filePath andKey:(int)key;
@end

@interface AUPresetManager : NSObject
//This creates a preset where each file's note is set to it's index in the filePaths array.
+(NSDictionary *)presetWithFilePaths:(NSArray <NSString *>*)filePaths oneShot:(BOOL)oneShot;
+(NSDictionary *)presetWithZones:(NSArray <AUPresetZone *> *)presetZones oneShot:(BOOL)oneShot;
+(NSDictionary *)samplerPreset:(AudioUnit)samplerUnit;
+(void)setPreset:(NSDictionary *)preset forSampler:(AudioUnit)sampler;
@end
