//
//  RFRecordButton.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/29.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFRecordButton;

typedef void (^RecordTouchDown)         (RFRecordButton *recordButton);
typedef void (^RecordTouchUpOutside)    (RFRecordButton *recordButton);
typedef void (^RecordTouchUpInside)     (RFRecordButton *recordButton);
typedef void (^RecordTouchDragEnter)    (RFRecordButton *recordButton);
typedef void (^RecordTouchDragInside)   (RFRecordButton *recordButton);
typedef void (^RecordTouchDragOutside)  (RFRecordButton *recordButton);
typedef void (^RecordTouchDragExit)     (RFRecordButton *recordButton);

@interface RFRecordButton : UIButton

@property (nonatomic, copy) RecordTouchDown         recordTouchDownAction;
@property (nonatomic, copy) RecordTouchUpOutside    recordTouchUpOutsideAction;
@property (nonatomic, copy) RecordTouchUpInside     recordTouchUpInsideAction;
@property (nonatomic, copy) RecordTouchDragEnter    recordTouchDragEnterAction;
@property (nonatomic, copy) RecordTouchDragInside   recordTouchDragInsideAction;
@property (nonatomic, copy) RecordTouchDragOutside  recordTouchDragOutsideAction;
@property (nonatomic, copy) RecordTouchDragExit     recordTouchDragExitAction;

- (void)setButtonStateWithRecording;
- (void)setButtonStateWithNormal;

@end
