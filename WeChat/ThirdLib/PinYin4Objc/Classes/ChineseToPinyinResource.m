//
//
//
//  Created by kimziv on 13-9-14.
//

#include "ChineseToPinyinResource.h"
#define LEFT_BRACKET @"("
#define RIGHT_BRACKET @")"
#define COMMA @","

#ifdef DEBUG
#define PYLog(...) NSLog(__VA_ARGS__)
#else
#define PYLog(__unused ...)
#endif

#define kCacheKeyForUnicode2Pinyin @"UnicodeToPinyin"
static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
	return [directory stringByAppendingPathComponent:key];
}

@interface ChineseToPinyinResource ()
- (id<NSCoding>)cachedObjectForKey:(NSString*)key;
-(void)cacheObjec:(id<NSCoding>)obj forKey:(NSString *)key;

@end

@implementation ChineseToPinyinResource

- (id)init {
    if (self = [super init]) {
        _unicodeToHanyuPinyinTable = nil;
        [self initializeResource];
    }
    return self;
}

- (void)initializeResource {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	_directory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"PinYinCache"] copy];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_directory])
    {
        NSError *error=nil;
        if (![fileManager createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:&error]) {
            PYLog(@"Error, s is %@, %s, %s, %d",error.description, __FILE__ ,__FUNCTION__, __LINE__);
        }
        
    }
    
    NSDictionary *dataMap=(NSDictionary *)[self cachedObjectForKey:kCacheKeyForUnicode2Pinyin];
    if (dataMap) {
        self->_unicodeToHanyuPinyinTable=dataMap;
    }else{
        NSString *resourceName =[[NSBundle mainBundle] pathForResource:@"unicode_to_hanyu_pinyin" ofType:@"txt"];
        NSString *dictionaryText=[NSString stringWithContentsOfFile:resourceName encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [dictionaryText componentsSeparatedByString:@"\r\n"];
        __block NSMutableDictionary *tempMap=[[NSMutableDictionary alloc] init];
        @autoreleasepool {
                [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSArray *lineComponents=[obj componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    [tempMap setObject:lineComponents[1] forKey:lineComponents[0]];
                }];
         }
        self->_unicodeToHanyuPinyinTable=tempMap;
        [self cacheObjec:self->_unicodeToHanyuPinyinTable forKey:kCacheKeyForUnicode2Pinyin];
    }
}

- (id<NSCoding>)cachedObjectForKey:(NSString*)key
{
    NSError *error=nil;
    NSData *data = [NSData dataWithContentsOfFile:cachePathForKey(_directory, key) options:0 error:&error];
   // NSAssert4((!error), @"Error, s is %@, %s, %s, %d",error.description, __FILE__ ,__FUNCTION__, __LINE__);
    if (!error) {
        if (data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return nil;
}

-(void)cacheObjec:(id<NSCoding>)obj forKey:(NSString *)key
{
    NSData* data= [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString* cachePath = cachePathForKey(_directory, key);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error=nil;
            [data writeToFile:cachePath options:NSDataWritingAtomic error:&error];
            if (error){
                PYLog(@"Error, s is %@, %s, %s, %d",error.description, __FILE__ ,__FUNCTION__, __LINE__);
            }
    });
}

- (NSArray *)getHanyuPinyinStringArrayWithChar:(unichar)ch {
    NSString *pinyinRecord = [self getHanyuPinyinRecordFromCharWithChar:ch];
    if (nil != pinyinRecord) {
        NSRange rangeOfLeftBracket= [pinyinRecord rangeOfString:LEFT_BRACKET];
        NSRange rangeOfRightBracket= [pinyinRecord rangeOfString:RIGHT_BRACKET];
        NSString *stripedString = [pinyinRecord substringWithRange:NSMakeRange(rangeOfLeftBracket.location+rangeOfLeftBracket.length, rangeOfRightBracket.location-rangeOfLeftBracket.location-rangeOfLeftBracket.length)];
        return [stripedString componentsSeparatedByString:COMMA];
    }
    else return nil;
}

- (BOOL)isValidRecordWithNSString:(NSString *)record {
    NSString *noneStr = @"(none0)";
    if ((nil != record) && ![record isEqual:noneStr] && [record hasPrefix:LEFT_BRACKET] && [record hasSuffix:RIGHT_BRACKET]) {
        return YES;
    }
    else return NO;
}

- (NSString *)getHanyuPinyinRecordFromCharWithChar:(unichar)ch {
    int codePointOfChar = ch;
    NSString *codepointHexStr =[[NSString stringWithFormat:@"%x", codePointOfChar] uppercaseString];
    NSString *foundRecord =[self->_unicodeToHanyuPinyinTable objectForKey:codepointHexStr];
    return [self isValidRecordWithNSString:foundRecord] ? foundRecord : nil;
}

+ (ChineseToPinyinResource *)getInstance {
    static ChineseToPinyinResource *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[self alloc] init];
    });
    return sharedInstance;
}

@end

