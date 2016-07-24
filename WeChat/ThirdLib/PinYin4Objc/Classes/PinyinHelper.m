//
//
//
//  Created by kimziv on 13-9-14.
//

#include "ChineseToPinyinResource.h"
#include "HanyuPinyinOutputFormat.h"
#include "PinyinFormatter.h"
#include "PinyinHelper.h"

#define HANYU_PINYIN @"Hanyu"
#define WADEGILES_PINYIN @"Wade"
#define MPS2_PINYIN @"MPSII"
#define YALE_PINYIN @"Yale"
#define TONGYONG_PINYIN @"Tongyong"
#define GWOYEU_ROMATZYH @"Gwoyeu"



@implementation PinyinHelper

//////async methods
+ (void)toHanyuPinyinStringArrayWithChar:(unichar)ch
                                  outputBlock:(OutputArrayBlock)outputBlock
{
       [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch outputBlock:outputBlock];
}

+ (void)toHanyuPinyinStringArrayWithChar:(unichar)ch
                  withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                                  outputBlock:(OutputArrayBlock)outputBlock
{
   return [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:ch withHanyuPinyinOutputFormat:outputFormat outputBlock:outputBlock];
}

+ (void)getFormattedHanyuPinyinStringArrayWithChar:(unichar)ch
                            withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                                            outputBlock:(OutputArrayBlock)outputBlock
{
    [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch outputBlock:^(NSArray *array) {
        if (outputBlock) {
            if (nil != array) {
                NSMutableArray *targetPinyinStringArray = [NSMutableArray arrayWithCapacity:array.count];
                for (int i = 0; i < (int) [array count]; i++) {
                    [targetPinyinStringArray replaceObjectAtIndex:i withObject:[PinyinFormatter formatHanyuPinyinWithNSString:
                                                                       [array objectAtIndex:i]withHanyuPinyinOutputFormat:outputFormat]];
                }
                outputBlock(targetPinyinStringArray);
            }
            else{
                outputBlock(nil);
            }
        }
    }];
}

+ (void)getUnformattedHanyuPinyinStringArrayWithChar:(unichar)ch
                                              outputBlock:(OutputArrayBlock)outputBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSArray *array= [[ChineseToPinyinResource getInstance] getHanyuPinyinStringArrayWithChar:ch];
       dispatch_async(dispatch_get_main_queue(), ^{
            if (outputBlock) {
                outputBlock(array);
            }
        });
    });
}

+ (void)toTongyongPinyinStringArrayWithChar:(unichar)ch
                                     outputBlock:(OutputArrayBlock)outputBlock
{
     return [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: TONGYONG_PINYIN outputBlock:outputBlock];
}

+ (void)toWadeGilesPinyinStringArrayWithChar:(unichar)ch
                                      outputBlock:(OutputArrayBlock)outputBlock
{
    [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: WADEGILES_PINYIN outputBlock:outputBlock];
}

+ (void)toMPS2PinyinStringArrayWithChar:(unichar)ch
                                 outputBlock:(OutputArrayBlock)outputBlock
{
     [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: MPS2_PINYIN outputBlock:outputBlock];
}

+ (void)toYalePinyinStringArrayWithChar:(unichar)ch
                                 outputBlock:(OutputArrayBlock)outputBlock
{
    [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: YALE_PINYIN outputBlock:outputBlock];
}

+ (void)convertToTargetPinyinStringArrayWithChar:(unichar)ch
                           withPinyinRomanizationType:(NSString *)targetPinyinSystem
                                          outputBlock:(OutputArrayBlock)outputBlock
{
    
     [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch outputBlock:^(NSArray *array) {
         if (outputBlock) {
             if (nil != array) {
                 NSMutableArray *targetPinyinStringArray = [NSMutableArray arrayWithCapacity:array.count];
                 for (int i = 0; i < (int) [array count]; i++) {
                    ///to do
                 }
                 outputBlock(targetPinyinStringArray);
             }
             else{
                 outputBlock(nil);
             }
         }
     }];
}
+ (void)toGwoyeuRomatzyhStringArrayWithChar:(unichar)ch
                                     outputBlock:(OutputArrayBlock)outputBlock
{
    
    [PinyinHelper convertToGwoyeuRomatzyhStringArrayWithChar:ch outputBlock:outputBlock];
}

+ (void)convertToGwoyeuRomatzyhStringArrayWithChar:(unichar)ch
                                            outputBlock:(OutputArrayBlock)outputBlock
{
    [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch outputBlock:^(NSArray *array) {
        if (outputBlock) {
            if (nil != array) {
                NSMutableArray *targetPinyinStringArray = [NSMutableArray arrayWithCapacity:array.count];
                for (int i = 0; i < (int) [array count]; i++) {
                    ///to do
                }
                outputBlock(targetPinyinStringArray);
            }
            else{
                outputBlock(nil);
            }
        }
    }];
 
}

+ (void)toHanyuPinyinStringWithNSString:(NSString *)str
            withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                           withNSString:(NSString *)seperater
                            outputBlock:(OutputStringBlock)outputBlock
{
 //   __block NSMutableString *resultPinyinStrBuf = [[NSMutableString alloc] init];
//    for (int i = 0; i <  str.length; i++) {
//         [PinyinHelper getFirstHanyuPinyinStringWithChar:[str characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat outputBlock:^(NSString *pinYin) {
//             if (nil != pinYin) {
//                 [resultPinyinStrBuf appendString:pinYin];
//                 if (i != [str length] - 1) {
//                     [resultPinyinStrBuf appendString:seperater];
//                 }
//             }
//             else {
//                 [resultPinyinStrBuf appendFormat:@"%C",[str characterAtIndex:i]];
//             }
//             if (outputBlock) {
//                 outputBlock(resultPinyinStrBuf);
//             }
//
//         }];
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableString *resultPinyinStrBuf = [[NSMutableString alloc] init];
        for (int i = 0; i <  str.length; i++) {
            NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[str characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
            if (nil != mainPinyinStrOfChar) {
                [resultPinyinStrBuf appendString:mainPinyinStrOfChar];
                if (i != [str length] - 1) {
                    [resultPinyinStrBuf appendString:seperater];
                }
            }
            else {
                [resultPinyinStrBuf appendFormat:@"%C",[str characterAtIndex:i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (outputBlock) {
                outputBlock(resultPinyinStrBuf);
            }
        });
    });
}

+ (void)getFirstHanyuPinyinStringWithChar:(unichar)ch
                    withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                                    outputBlock:(OutputStringBlock)outputBlock
{
    [self getFormattedHanyuPinyinStringArrayWithChar:ch withHanyuPinyinOutputFormat:outputFormat outputBlock:^(NSArray *array) {
        if (outputBlock) {
            if ((nil != array) && ((int) [array count] > 0)) {
                outputBlock([array objectAtIndex:0]);
            }else {
               outputBlock(nil);
            }
            
        }
    }];
}

/////sync methods

+ (NSArray *)toHanyuPinyinStringArrayWithChar:(unichar)ch {
    return [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch];
}

+ (NSArray *)toHanyuPinyinStringArrayWithChar:(unichar)ch
                  withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat {
    return [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:ch withHanyuPinyinOutputFormat:outputFormat];
}

+ (NSArray *)getFormattedHanyuPinyinStringArrayWithChar:(unichar)ch
                            withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat {
    NSMutableArray *pinyinStrArray =[NSMutableArray arrayWithArray:[PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch]];
    if (nil != pinyinStrArray) {
        for (int i = 0; i < (int) [pinyinStrArray count]; i++) {
            [pinyinStrArray replaceObjectAtIndex:i withObject:[PinyinFormatter formatHanyuPinyinWithNSString:
                                                               [pinyinStrArray objectAtIndex:i]withHanyuPinyinOutputFormat:outputFormat]];
        }
        return pinyinStrArray;
    }
    else return nil;
}

+ (NSArray *)getUnformattedHanyuPinyinStringArrayWithChar:(unichar)ch {
    return [[ChineseToPinyinResource getInstance] getHanyuPinyinStringArrayWithChar:ch];
}

+ (NSArray *)toTongyongPinyinStringArrayWithChar:(unichar)ch {
    return [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: TONGYONG_PINYIN];
}

+ (NSArray *)toWadeGilesPinyinStringArrayWithChar:(unichar)ch {
    return [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: WADEGILES_PINYIN];
}

+ (NSArray *)toMPS2PinyinStringArrayWithChar:(unichar)ch {
    return [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: MPS2_PINYIN];
}

+ (NSArray *)toYalePinyinStringArrayWithChar:(unichar)ch {
    return [PinyinHelper convertToTargetPinyinStringArrayWithChar:ch withPinyinRomanizationType: YALE_PINYIN];
}

+ (NSArray *)convertToTargetPinyinStringArrayWithChar:(unichar)ch
                           withPinyinRomanizationType:(NSString *)targetPinyinSystem {
    NSArray *hanyuPinyinStringArray = [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch];
    if (nil != hanyuPinyinStringArray) {
        NSMutableArray *targetPinyinStringArray = [NSMutableArray arrayWithCapacity:hanyuPinyinStringArray.count];
        for (int i = 0; i < (int) [hanyuPinyinStringArray count]; i++) {
            
        }
        return targetPinyinStringArray;
    }
    else return nil;
}

+ (NSArray *)toGwoyeuRomatzyhStringArrayWithChar:(unichar)ch {
    return [PinyinHelper convertToGwoyeuRomatzyhStringArrayWithChar:ch];
}

+ (NSArray *)convertToGwoyeuRomatzyhStringArrayWithChar:(unichar)ch {
    NSArray *hanyuPinyinStringArray = [PinyinHelper getUnformattedHanyuPinyinStringArrayWithChar:ch];
    if (nil != hanyuPinyinStringArray) {
        NSMutableArray *targetPinyinStringArray =[NSMutableArray arrayWithCapacity:hanyuPinyinStringArray.count];
        for (int i = 0; i < (int) [hanyuPinyinStringArray count]; i++) {
        }
        return targetPinyinStringArray;
    }
    else return nil;
}

+ (NSString *)toHanyuPinyinStringWithNSString:(NSString *)str
                  withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                                 withNSString:(NSString *)seperater {
    NSMutableString *resultPinyinStrBuf = [[NSMutableString alloc] init];
    for (int i = 0; i <  str.length; i++) {
        NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[str characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil != mainPinyinStrOfChar) {
            [resultPinyinStrBuf appendString:mainPinyinStrOfChar];
            if (i != [str length] - 1) {
                [resultPinyinStrBuf appendString:seperater];
            }
        }
        else {
            [resultPinyinStrBuf appendFormat:@"%C",[str characterAtIndex:i]];
        }
    }
    return resultPinyinStrBuf;
}

+ (NSString *)getFirstHanyuPinyinStringWithChar:(unichar)ch
                    withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat {
    NSArray *pinyinStrArray = [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:ch withHanyuPinyinOutputFormat:outputFormat];
    if ((nil != pinyinStrArray) && ((int) [pinyinStrArray count] > 0)) {
        return [pinyinStrArray objectAtIndex:0];
    }
    else {
        return nil;
    }
}
+ (BOOL)isIncludeChineseInString:(NSString*)str{
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
