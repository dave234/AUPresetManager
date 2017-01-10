//
//  AUPresetManager.m
//
//  Created by David O'Neill on 1/8/17.
//  Copyright © 2017 David O'Neill. All rights reserved.
//

#import "AUPresetManager.h"


#define FILEREFPREFIX @"Sample:"
#define STARTINGWAVEFORMID 268435457


@interface NSDictionary (aupreset)
@property (readonly)    NSMutableDictionary *fileReferences;
@property (readonly)    NSMutableArray      *layers;
@property               BOOL                oneShot;
@end

@implementation NSDictionary (aupreset)
-(NSMutableDictionary *)fileReferences{
    return self[@"file-references"];
}
-(NSMutableArray <NSDictionary *> *)layers{
    return self[@"Instrument"][@"Layers"];
}
-(NSMutableArray *)zones{
    return self.layers[0][@"Zones"];
}
-(BOOL)oneShot{
    NSNumber *oneShot = self.layers[0][@"trigger mode"];
    return oneShot && [oneShot isEqual:@11] ? YES : NO;
}
-(void)setOneShot:(BOOL)oneShot{
    if (oneShot) {
        self.layers[0][@"trigger mode"] = @11;
    }
    else{
        [self.layers[0] removeObjectForKey:@"trigger mode"];
    }
}
                              
@end


@interface AUPresetZone ()
@property NSNumber *ID;
@property NSNumber  *waveform;
@end
@implementation AUPresetZone
-(NSDictionary *)asDictionary{
    return @{@"enabled":@(self.enabled),
             @"loop enabled":@(self.loopEnabled),
             @"max key":@(self.maxKey),
             @"min key":@(self.minKey),
             @"root key":@(self.rootKey),
             @"pitch tracking":@(self.pitchTracking),
             @"waveform":self.waveform,
             @"ID":self.ID};
}
-(instancetype)initWithFilePath:(NSString *)filePath andKey:(int)key{
    self = [super init];
    if (self) {
        self.enabled = 1;
        self.loopEnabled = 0;
        self.maxKey = self.minKey = self.rootKey = key;
        self.pitchTracking = 0;
        self.filePath = filePath;
    }
    return self;
}
+(AUPresetZone *)WithFilePath:(NSString *)filePath andKey:(int)key{
    return [[AUPresetZone alloc]initWithFilePath:filePath andKey:key];
}
@end


@implementation AUPresetManager

+(NSDictionary *)presetWithZones:(NSArray <AUPresetZone *> *)presetZones oneShot:(BOOL)oneShot{
    NSMutableDictionary *preset = mutableSkeleton();
    NSDictionary *waveFormIds = waveformsPathIndexed(presetZones);
    if(!waveFormIds)return NULL;
    for (NSString *path in waveFormIds.allKeys){
        NSNumber *waveFormId = waveFormIds[path];
        NSString *sampleKey = [FILEREFPREFIX stringByAppendingString:waveFormId.stringValue];
        preset.fileReferences[sampleKey] = path;
    }
    int ID = 1;
    for (AUPresetZone *presetZone in presetZones){
        presetZone.ID = @(ID);
        presetZone.waveform = waveFormIds[presetZone.filePath];
        [preset.zones addObject:presetZone.asDictionary];
    }
    preset.oneShot = oneShot;
    return preset;
}

NSDictionary *waveformsPathIndexed(NSArray <AUPresetZone *> *presetZones){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSSet *filePaths = [NSSet setWithArray:[presetZones valueForKey:@"filePath"]];
    NSMutableDictionary *waveformsPathIndexed = [[NSMutableDictionary alloc]init];
    int nextWaveformId = STARTINGWAVEFORMID;
    for (NSString *path in filePaths){
        if(![fileManager fileExistsAtPath:path]){
            NSLog(@"file doesn't exist at %@",path);
        }
        waveformsPathIndexed[path] = @(nextWaveformId);
        nextWaveformId++;
    }
    return waveformsPathIndexed;
}
NSMutableDictionary *mutableSkeleton(){
    static NSDictionary *skeleton = NULL;
    if (!skeleton) {
        NSString *skeletonPath = [@"AUPresetManager.bundle" stringByAppendingPathComponent:@"Skeleton"];
        NSURL *skeletonURL = [[NSBundle mainBundle] URLForResource:skeletonPath withExtension:@"aupreset"];
        if(!skeletonURL){
            skeletonURL = [[NSBundle mainBundle]URLForResource:@"Skeleton" withExtension:@"aupreset"];
        }
        if(!skeletonURL){
            NSLog(@"Skeleton file not found");
            return NULL;
        }
        skeleton = [NSDictionary dictionaryWithContentsOfURL:skeletonURL];
    }
    
    NSMutableDictionary *_preset = skeleton.mutableCopy;
    _preset[@"file-references"] = [NSMutableDictionary new];
    NSMutableDictionary *_instrument = _preset[@"Instrument"] = [_preset[@"Instrument"] mutableCopy];
    NSMutableArray *layers = _instrument[@"Layers"] = [_instrument[@"Layers"]mutableCopy];
    NSMutableDictionary *layersObject = layers[0] = [layers[0] mutableCopy];
    layersObject[@"Zones"] = [layersObject[@"Zones"]mutableCopy];
    return _preset;
}
@end
