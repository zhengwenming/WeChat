//
//  
//
//  Created by kimziv on 13-9-14.
//

#include "HanyuPinyinOutputFormat.h"
#include "PinyinFormatter.h"
#import "NSString+PinYin4Cocoa.h"

@interface PinyinFormatter ()
+(NSInteger)getNumericValue:(unichar)c;
+(NSInteger)indexOfChar:(int*) table ch:(unichar)c;
@end    

@implementation PinyinFormatter

static int numericKeys[] = {
    0x0030, 0x0041, 0x0061, 0x00b2, 0x00b9, 0x00bc, 0x0660, 0x06f0,
    0x0966, 0x09e6, 0x09f4, 0x09f9, 0x0a66, 0x0ae6, 0x0b66, 0x0be7,
    0x0bf1, 0x0bf2, 0x0c66, 0x0ce6, 0x0d66, 0x0e50, 0x0ed0, 0x0f20,
    0x1040, 0x1369, 0x1373, 0x1374, 0x1375, 0x1376, 0x1377, 0x1378,
    0x1379, 0x137a, 0x137b, 0x137c, 0x16ee, 0x17e0, 0x1810, 0x2070,
    0x2074, 0x2080, 0x2153, 0x215f, 0x2160, 0x216c, 0x216d, 0x216e,
    0x216f, 0x2170, 0x217c, 0x217d, 0x217e, 0x217f, 0x2180, 0x2181,
    0x2182, 0x2460, 0x2474, 0x2488, 0x24ea, 0x2776, 0x2780, 0x278a,
    0x3007, 0x3021, 0x3038, 0x3039, 0x303a, 0x3280, 0xff10, 0xff21,
    0xff41,
};

static unichar numericValues[] = {
    0x0039, 0x0030, 0x005a, 0x0037, 0x007a, 0x0057, 0x00b3, 0x00b0,
    0x00b9, 0x00b8, 0x00be, 0x0000, 0x0669, 0x0660, 0x06f9, 0x06f0,
    0x096f, 0x0966, 0x09ef, 0x09e6, 0x09f7, 0x09f3, 0x09f9, 0x09e9,
    0x0a6f, 0x0a66, 0x0aef, 0x0ae6, 0x0b6f, 0x0b66, 0x0bf0, 0x0be6,
    0x0bf1, 0x0b8d, 0x0bf2, 0x080a, 0x0c6f, 0x0c66, 0x0cef, 0x0ce6,
    0x0d6f, 0x0d66, 0x0e59, 0x0e50, 0x0ed9, 0x0ed0, 0x0f29, 0x0f20,
    0x1049, 0x1040, 0x1372, 0x1368, 0x1373, 0x135f, 0x1374, 0x1356,
    0x1375, 0x134d, 0x1376, 0x1344, 0x1377, 0x133b, 0x1378, 0x1332,
    0x1379, 0x1329, 0x137a, 0x1320, 0x137b, 0x1317, 0x137c, 0xec6c,
    0x16f0, 0x16dd, 0x17e9, 0x17e0, 0x1819, 0x1810, 0x2070, 0x2070,
    0x2079, 0x2070, 0x2089, 0x2080, 0x215e, 0x0000, 0x215f, 0x215e,
    0x216b, 0x215f, 0x216c, 0x213a, 0x216d, 0x2109, 0x216e, 0x1f7a,
    0x216f, 0x1d87, 0x217b, 0x216f, 0x217c, 0x214a, 0x217d, 0x2119,
    0x217e, 0x1f8a, 0x217f, 0x1d97, 0x2180, 0x1d98, 0x2181, 0x0df9,
    0x2182, 0xfa72, 0x2473, 0x245f, 0x2487, 0x2473, 0x249b, 0x2487,
    0x24ea, 0x24ea, 0x277f, 0x2775, 0x2789, 0x277f, 0x2793, 0x2789,
    0x3007, 0x3007, 0x3029, 0x3020, 0x3038, 0x302e, 0x3039, 0x3025,
    0x303a, 0x301c, 0x3289, 0x327f, 0xff19, 0xff10, 0xff3a, 0xff17,
    0xff5a, 0xff37,
};


+ (NSString *)formatHanyuPinyinWithNSString:(NSString *)pinyinStr
                withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat {
  if ((ToneTypeWithToneMark == [outputFormat toneType]) && ((VCharTypeWithV == [outputFormat vCharType]) || (VCharTypeWithUAndColon == [outputFormat vCharType]))) {
      @throw [NSException exceptionWithName:@"Throwing a BadHanyuPinyinOutputFormatCombination exception" reason:@"tone marks cannot be added to v or u:." userInfo:nil];
  }
  if (ToneTypeWithoutTone == [outputFormat toneType]) {
      pinyinStr =[pinyinStr stringByReplacingOccurrencesOfString:@"[1-5]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, pinyinStr.length)];
  }
  else if (ToneTypeWithToneMark == [outputFormat toneType]) {
      pinyinStr =[pinyinStr stringByReplacingOccurrencesOfString:@"u:" withString:@"v"];
     pinyinStr = [PinyinFormatter convertToneNumber2ToneMarkWithNSString:pinyinStr];
  }
  if (VCharTypeWithV == [outputFormat vCharType]) {
      pinyinStr =[pinyinStr stringByReplacingOccurrencesOfString:@"u:" withString:@"v"];
  }
  else if (VCharTypeWithUUnicode == [outputFormat vCharType]) {
      pinyinStr =[pinyinStr stringByReplacingOccurrencesOfString:@"u:" withString:@"ü"];
  }
  if (CaseTypeUppercase == [outputFormat caseType]) {
    pinyinStr = [pinyinStr uppercaseString];
  }
  return pinyinStr;
}

+ (NSString *)convertToneNumber2ToneMarkWithNSString:(NSString *)pinyinStr {
  NSString *lowerCasePinyinStr = [pinyinStr lowercaseString];
  if ([lowerCasePinyinStr matchesPatternRegexPattern:@"[a-z]*[1-5]?"]) {
    unichar defautlCharValue = '$';
    int defautlIndexValue = -1;
    unichar unmarkedVowel = defautlCharValue;
    int indexOfUnmarkedVowel = defautlIndexValue;
    unichar charA = 'a';
    unichar charE = 'e';
    NSString *ouStr = @"ou";
    NSString *allUnmarkedVowelStr = @"aeiouv";
    NSString *allMarkedVowelStr = @"āáăàaēéĕèeīíĭìiōóŏòoūúŭùuǖǘǚǜü";
    if ([lowerCasePinyinStr matchesPatternRegexPattern:@"[a-z]*[1-5]"]) {
        int tuneNumber = [PinyinFormatter getNumericValue:[lowerCasePinyinStr characterAtIndex:lowerCasePinyinStr.length -1]];
      int indexOfA = [lowerCasePinyinStr indexOf:charA];
      int indexOfE = [lowerCasePinyinStr indexOf:charE];
      int ouIndex = [lowerCasePinyinStr indexOfString:ouStr];
      if (-1 != indexOfA) {
        indexOfUnmarkedVowel = indexOfA;
        unmarkedVowel = charA;
      }
      else if (-1 != indexOfE) {
        indexOfUnmarkedVowel = indexOfE;
        unmarkedVowel = charE;
      }
      else if (-1 != ouIndex) {
        indexOfUnmarkedVowel = ouIndex;
        unmarkedVowel = [ouStr characterAtIndex:0];
      }
      else {
        for (int i = [lowerCasePinyinStr length] - 1; i >= 0; i--) {
          if ([[NSString valueOfChar:[lowerCasePinyinStr characterAtIndex:i]] matchesPatternRegexPattern:@"[aeiouv]"]) {
            indexOfUnmarkedVowel = i;
            unmarkedVowel = [lowerCasePinyinStr characterAtIndex:i];
            break;
          }
        }
      }
      if ((defautlCharValue != unmarkedVowel) && (defautlIndexValue != indexOfUnmarkedVowel)) {
        int rowIndex = [allUnmarkedVowelStr indexOf:unmarkedVowel];
        int columnIndex = tuneNumber - 1;
        int vowelLocation = rowIndex * 5 + columnIndex;
        unichar markedVowel = [allMarkedVowelStr characterAtIndex:vowelLocation];
        NSMutableString *resultBuffer = [[NSMutableString alloc] init];
          [resultBuffer appendString:[[lowerCasePinyinStr substringToIndex:indexOfUnmarkedVowel+1] stringByReplacingOccurrencesOfString:@"v" withString:@"ü"]];
        [resultBuffer appendFormat:@"%C",markedVowel];
          [resultBuffer appendString:[[lowerCasePinyinStr substringWithRange:NSMakeRange(indexOfUnmarkedVowel + 1, lowerCasePinyinStr.length-indexOfUnmarkedVowel)] stringByReplacingOccurrencesOfString:@"v" withString:@"ü"]];
        return [resultBuffer description];
      }
      else {
        return lowerCasePinyinStr;
      }
    }
    else {
      return [lowerCasePinyinStr stringByReplacingOccurrencesOfString:@"v" withString:@"ü"];
    }
  }
  else {
    return lowerCasePinyinStr;
  }
}

+(NSInteger)getNumericValue:(unichar)c
{
    if (c < 128) {
        // Optimized for ASCII
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'a' && c <= 'z') {
            return c - ('a' - 10);
        }
        if (c >= 'A' && c <= 'Z') {
            return c - ('A' - 10);
        }
        return -1;
    }
    NSInteger result = [self indexOfChar:numericKeys ch:c];
    if (result >= 0 && c <= numericValues[result * 2]) {
        unichar difference = numericValues[result * 2 + 1];
        if (difference == 0) {
            return -2;
        }
        // Value is always positive, must be negative value
        if (difference > c) {
            return c - (short) difference;
        }
        return c - difference;
    }
    return -1;

}

+(NSInteger)indexOfChar:(int*) table ch:(unichar)c{
    NSInteger len=sizeof(table)/sizeof(table[0]);
    for (int i = 0; i < len; i++) {
        if (table[i] == (int) c) {
            return i;
        }
    }
    return -1;
}


- (id)init {
  return [super init];
}



@end
