//
//  CLLPickerDate.h
//  CLLPickerDateDemo
//
//  Created by leocll on 2017/9/6.
//  Copyright © 2017年 leocll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, CLLPickerDateOptions) {
	CLLPickerDateYear = 1<<0,			//年
	CLLPickerDateMonth = 1<<1,			//月
	CLLPickerDateDay = 1<<2,			//日
	CLLPickerDateHour = 1<<3,			//时
	CLLPickerDateMinute = 1<<4,			//分
	CLLPickerDateSecond = 1<<5,			//秒
};

typedef NSString * CLLPickerDateSelectedKey NS_STRING_ENUM;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedYearKey;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedMonthKey;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedDayKey;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedHourKey;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedMinuteKey;
FOUNDATION_EXPORT CLLPickerDateSelectedKey const CLLPickerDateSelectedSecondKey;

@interface CLLPickerDate : UIView
/**数据源类型，默认年月日*/
@property (nonatomic, assign) CLLPickerDateOptions mode;
/**选中的时间，默认当前的时间*/
@property (nonatomic, strong) NSDate *date;
/**被选中值的字典*/
@property (nonatomic, strong, readonly) NSDictionary <CLLPickerDateSelectedKey,NSNumber *>* selectedValueDictionary;
/**日期的标题回调*/
@property (nonatomic, copy) NSString *(^titleBlock)(CLLPickerDateOptions option, NSString *title);
/**日期的属性标题回调*/
@property (nonatomic, copy) NSAttributedString *(^attributedTitleBlock)(CLLPickerDateOptions option, NSString *title);
/**选择的回调*/
@property (nonatomic, copy) void(^selectedValueBlock)(CLLPickerDateOptions option, NSDictionary <CLLPickerDateSelectedKey,NSNumber *>* selectedValueDictionary);
/**点击确定的回调*/
@property (nonatomic, copy) void(^touchesSureBlock)(NSDictionary <CLLPickerDateSelectedKey,NSNumber *>* selectedValueDictionary, NSDate *date);
/**点击取消的回调*/
@property (nonatomic, copy) void(^touchesCancelBlock)(void);
/**
 显示
 */
- (void)show;
@end
NS_ASSUME_NONNULL_END
