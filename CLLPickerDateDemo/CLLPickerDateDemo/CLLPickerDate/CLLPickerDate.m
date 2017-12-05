//
//  CLLPickerDate.m
//  CLLPickerDateDemo
//
//  Created by leocll on 2017/9/6.
//  Copyright © 2017年 leocll. All rights reserved.
//

#import "CLLPickerDate.h"
#import <objc/runtime.h>
#import "UIView+CLLFrame.h"

#ifndef EXECUTE_BLOCK
#define EXECUTE_BLOCK(A,...) if(A){A(__VA_ARGS__);}
#endif

#ifndef RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#endif

@interface NSDate (CLLPickerDate)
/**所在的年*/
@property (nonatomic, assign, readonly) NSInteger cll_year;
/**所在的月*/
@property (nonatomic, assign, readonly) NSInteger cll_month;
/**所在的日*/
@property (nonatomic, assign, readonly) NSInteger cll_day;
/**所在的时*/
@property (nonatomic, assign, readonly) NSInteger cll_hour;
/**所在的分*/
@property (nonatomic, assign, readonly) NSInteger cll_minute;
/**所在的秒*/
@property (nonatomic, assign, readonly) NSInteger cll_second;
/**所在月的天数*/
@property (nonatomic, assign, readonly) NSInteger cll_daysInMonth;

- (NSDate *)cll_dateWithYear:(NSInteger)year month:(NSInteger)month;

- (NSDate *)cll_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (NSDate *)cll_dateWithPickerValueDictionary:(NSDictionary<CLLPickerDateSelectedKey,NSNumber *> *)dic;
@end

@interface CLLPickerDateModel : NSObject
/**数据源*/
@property (nonatomic, strong) NSMutableArray <NSString *>*dataArray;
/**最小数据源*/
@property (nonatomic, strong) NSMutableArray <NSString *>*minDataArray;
/**最大数据源*/
@property (nonatomic, strong) NSMutableArray <NSString *>*maxDataArray;
/**被选中的数据*/
@property (nonatomic, assign) NSInteger selectedData;
/**所在的component*/
@property (nonatomic, assign) NSInteger component;
/**模式*/
@property (nonatomic, assign) CLLPickerDateOptions option;
/**后缀*/
@property (nonatomic, strong) NSString *suffix;
@end
@implementation CLLPickerDateModel
@end

#define kRowHeight 44
@interface CLLPickerDate ()<UIPickerViewDataSource,UIPickerViewDelegate>
/**数据源*/
@property (nonatomic, strong) NSMutableArray <CLLPickerDateModel *>*arrPDM;
/**年数据源*/
@property (nonatomic, strong) CLLPickerDateModel *year;
/**月数据源*/
@property (nonatomic, strong) CLLPickerDateModel *month;
/**日数据源*/
@property (nonatomic, strong) CLLPickerDateModel *day;
/**时数据源*/
@property (nonatomic, strong) CLLPickerDateModel *hour;
/**分数据源*/
@property (nonatomic, strong) CLLPickerDateModel *minute;
/**秒数据源*/
@property (nonatomic, strong) CLLPickerDateModel *second;
/**拾取器*/
@property (nonatomic, strong) UIPickerView *pickerView;
/**操作视图*/
@property (nonatomic, strong) UIView *operationView;
/**背景视图*/
@property (nonatomic, strong) UIView *bgView;
/**列宽*/
@property (nonatomic, assign) CGFloat componentWidth;
/**是否包含日*/
@property (nonatomic, assign) BOOL containDay;
@end

@implementation CLLPickerDate

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		// 初始化UI
		[self createUI];
        // 初始化默认数据
        [self createDefaultData];
		// 更新UI
		[self updateUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)createUI {
	self.width = self.width ? self.width : kScreenWidth;
	self.clipsToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];
	// 操作视图
	self.operationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kRowHeight)];
	[self addSubview:self.operationView];
    // 取消按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(52, 52, 52, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchesCancel) forControlEvents:UIControlEventTouchUpInside];
    btn.height = kRowHeight;
    btn.width = 60;
    [self.operationView addSubview:btn];
    // 确定按钮
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(52, 52, 52, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchesSure) forControlEvents:UIControlEventTouchUpInside];
    btn.height = kRowHeight;
    btn.width = 60;
    btn.right = self.operationView.width;
    [self.operationView addSubview:btn];
    // 横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBA(200, 200, 200, 1);
    line.height = 0.5;
    line.width = self.operationView.width;
    line.bottom = self.operationView.height;
    [self.operationView addSubview:line];
	// 拾取器
	self.pickerView = [[UIPickerView alloc] init];
	self.pickerView.width = self.width;
	self.pickerView.top = self.operationView.bottom;
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	[self addSubview:self.pickerView];
	
	self.height = self.pickerView.bottom;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
	_arrPDM = [NSMutableArray array];
	_year = [[CLLPickerDateModel alloc] init];
	_year.option = CLLPickerDateYear;
	_year.suffix = @"年";
	_month = [[CLLPickerDateModel alloc] init];
	_month.option = CLLPickerDateMonth;
	_month.suffix = @"月";
	_day = [[CLLPickerDateModel alloc] init];
	_day.option = CLLPickerDateDay;
	_day.suffix = @"日";
	_hour = [[CLLPickerDateModel alloc] init];
	_hour.option = CLLPickerDateHour;
	_hour.suffix = @"时";
	_minute = [[CLLPickerDateModel alloc] init];
	_minute.option = CLLPickerDateMinute;
	_minute.suffix = @"分";
	_second = [[CLLPickerDateModel alloc] init];
	_second.option = CLLPickerDateSecond;
	_second.suffix = @"秒";
	
	_mode = CLLPickerDateYear | CLLPickerDateMonth | CLLPickerDateDay;
	[self handleMode];
	_date = [NSDate date];
	[self handleDate];
}

#pragma mark - 处理mode
- (void)handleMode {
	_containDay = NO;
	[_arrPDM removeAllObjects];
	NSInteger i = 0;
	if (_mode & CLLPickerDateYear) {
		[_arrPDM addObject:_year];
		_year.component = i++;
	}
	if (_mode & CLLPickerDateMonth) {
		[_arrPDM addObject:_month];
		_month.dataArray = [self stringsWithMin:1 max:12 repeat:YES];
		_month.component = i++;
	}
	if (_mode & CLLPickerDateDay) {
		[_arrPDM addObject:_day];
		_day.component = i++;
		_containDay = YES;
	}
	if (_mode & CLLPickerDateHour) {
		[_arrPDM addObject:_hour];
		_hour.dataArray = [self stringsWithMin:0 max:23 repeat:YES];
		_hour.component = i++;
	}
	if (_mode & CLLPickerDateMinute) {
		[_arrPDM addObject:_minute];
		_minute.dataArray = [self stringsWithMin:0 max:59 repeat:YES];
		_minute.component = i++;
	}
	if (_mode & CLLPickerDateSecond) {
		[_arrPDM addObject:_second];
		_second.dataArray = [self stringsWithMin:0 max:59 repeat:YES];
		_second.component = i++;
	}
}

#pragma mark - 处理date
- (void)handleDate {
	_year.selectedData = _date.cll_year;
	_month.selectedData = _date.cll_month;
	_day.selectedData = _date.cll_day;
	_hour.selectedData = _date.cll_hour;
	_minute.selectedData = _date.cll_minute;
	_second.selectedData = _date.cll_second;
}

#pragma mark - 处理year数据
- (void)handleYearData {
	NSInteger min = _date.cll_year-10;
	min = min<1970 ? 1970 : min;
	NSInteger max = _date.cll_year+10;
	if (min != _year.dataArray.firstObject.integerValue || max != _year.dataArray.lastObject.integerValue) {
		_year.dataArray = [self stringsWithMin:min max:max repeat:NO];
	}
}

#pragma mark - 处理day数据
- (void)handleDayData {
	NSInteger dayCount = [_date cll_dateWithYear:_year.selectedData month:_month.selectedData].cll_daysInMonth;
	if (dayCount != _day.dataArray.count) {
		_day.dataArray = [self stringsWithMin:1 max:dayCount repeat:YES];
	}
}

#pragma mark - 更新UI
- (void)updateUI {
	[self handleYearData];
	[self handleDayData];
	_componentWidth = (self.width-_arrPDM.count*10) / (_arrPDM.count<3 ? 3 : _arrPDM.count);
	[self.pickerView reloadAllComponents];
	[self updateSelectedRowsWithAnimated:YES];
}

- (void)updateYearUI {
	if (_year.selectedData == _year.dataArray.firstObject.integerValue) {// 之前插入数据
		if (_year.selectedData > 1970) {
			NSInteger min = _year.selectedData-11;
			min = min<1970 ? 1970 : min;
			NSInteger max = _year.selectedData-1;
			max = max<1970 ? 1970 : max;
			NSArray *arr = _year.dataArray.copy;
			[_year.dataArray removeAllObjects];
			[_year.dataArray addObjectsFromArray:[self stringsWithMin:min max:max repeat:NO]];
			[_year.dataArray addObjectsFromArray:arr];
			[self.pickerView reloadComponent:_year.component];
			[self updateSelectedRowForModel:_year animated:NO];
		}
	} else if (_year.selectedData == _year.dataArray.lastObject.integerValue) {// 之后加数据
		[_year.dataArray addObjectsFromArray:[self stringsWithMin:_year.selectedData+1 max:_year.selectedData+11 repeat:NO]];
		[self.pickerView reloadComponent:_year.component];
	} else {
		//未用
	}
}

- (void)updateDayUI {
	if (!_containDay) {return;}
	[self handleDayData];
	[self.pickerView reloadComponent:_day.component];
	if (_day.dataArray.lastObject.integerValue < _day.selectedData) {// 处理日选择31，月选择2的这类情况
		_day.selectedData = _day.dataArray.lastObject.integerValue;
	}
	[self updateSelectedRowForModel:_day animated:NO];
}

- (void)updateSelectedRowsWithAnimated:(BOOL)animated {
	for (CLLPickerDateModel *model in _arrPDM) {
		[self updateSelectedRowForModel:model animated:animated];
	}
}

- (void)updateSelectedRowForModel:(CLLPickerDateModel *)model animated:(BOOL)animated {
	if (![_arrPDM containsObject:model]) {return;}
	NSInteger row = 0;
	if (model == _year) {// 年
		row = _year.selectedData-_year.dataArray.firstObject.integerValue;
	} else {
		if (model == _month || model == _day) {// 月、日从1开始的
			row = model.selectedData - 1;
		} else {
			row = model.selectedData;
		}
        // 为了循环效果
        row = row<6 ? row+model.dataArray.count*0.5 : row;
	}
	if (row < 0) {return;}
	[self.pickerView selectRow:row inComponent:model.component animated:animated];
	NSLog(@"row:%ld，value:%@",row,[NSString stringWithFormat:@"%@%@",model.dataArray[row],model.suffix]);
}

#pragma mark - 数字数组
- (NSMutableArray <NSString *>*)stringsWithMin:(NSInteger)min max:(NSInteger)max repeat:(BOOL)isRepeat {
	if (min > max) {return nil;}
	NSMutableArray *arr = [NSMutableArray array];
	for (NSInteger i = min; i <= max; i++) {
		[arr addObject:@(i).stringValue];
	}
	if (isRepeat) {
		[arr addObjectsFromArray:[self stringsWithMin:min max:max repeat:NO]];
	}
	return arr;
}

#pragma mark - 显示
- (void)show {
	self.bgView.backgroundColor = RGBA(0, 0, 0, 0);
	[self.bgView addSubview:self];
	[[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
	self.top = self.bgView.height;
	[UIView animateWithDuration:0.4 animations:^{
		self.bgView.backgroundColor = RGBA(0, 0, 0, 0.4);
		self.bottom = self.bgView.height - kSafeBottomMargin;
	}];
}

#pragma mark - 消失
- (void)dismiss {
	[UIView animateWithDuration:0.4 animations:^{
		self.bgView.backgroundColor = RGBA(0, 0, 0, 0);
		self.top = self.bgView.height;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		[self.bgView removeFromSuperview];
	}];
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame {
	frame.size.height = self.pickerView.bottom;
	[super setFrame:frame];
	self.pickerView.width = frame.size.width;
}

- (void)setMode:(CLLPickerDateOptions)mode {
	_mode = mode;
	[self handleMode];
	[self updateUI];
}

- (void)setDate:(NSDate *)date {
	_date = date;
	[self handleDate];
    [self handleYearData];
	[self updateSelectedRowsWithAnimated:YES];
}

#pragma mark - 点击事件
#pragma mark 点击取消
- (void)touchesCancel {
	[self dismiss];
	EXECUTE_BLOCK(_touchesCancelBlock);
}

#pragma mark 点击确定
- (void)touchesSure {
	[self dismiss];
	if (_touchesSureBlock) {
		NSDictionary *dic = self.selectedValueDictionary;
		_touchesSureBlock(dic,[_date cll_dateWithPickerValueDictionary:dic]);
	}
}

#pragma mark - ------------- UIPickerViewDataSource && UIPickerViewDelegate --------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return _arrPDM.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return _arrPDM[component].dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return _componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return kRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [view viewWithTag:1111];
	if (!label) {
		view = [[UIView alloc] init];
		label = [UILabel new];
		label.tag = 1111;
		label.font = [UIFont boldSystemFontOfSize:14];
		label.textColor = RGBA(52, 52, 52, 1);
		label.textAlignment = NSTextAlignmentCenter;
		[view addSubview:label];
	}
	view.size = CGSizeMake(_componentWidth, kRowHeight);
	label.size = view.size;
	
	NSString *title = _arrPDM[component].dataArray[row];
	if (_attributedTitleBlock) {
		label.attributedText = _attributedTitleBlock(_arrPDM[component].option,title);
	} else {
		if (_titleBlock) {
			label.text = _titleBlock(_arrPDM[component].option,title);
		} else {
			label.text = [NSString stringWithFormat:@"%@%@",title,_arrPDM[component].suffix];
		}
	}
	return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	CLLPickerDateModel *model = _arrPDM[component];
	model.selectedData = model.dataArray[row].integerValue;
	if (model.option == CLLPickerDateYear || model.option == CLLPickerDateMonth) {
		[self updateDayUI];
		if (model.option == CLLPickerDateYear) {
			[self updateYearUI];
		}
	}
	[self updateSelectedRowForModel:model animated:NO];
	if (_selectedValueBlock) {
		_selectedValueBlock(model.option,self.selectedValueDictionary);
	}
}

#pragma mark - getter
NSString * const CLLPickerDateSelectedYearKey = @"CLLPickerDateYear";
NSString * const CLLPickerDateSelectedMonthKey = @"CLLPickerDateMonth";
NSString * const CLLPickerDateSelectedDayKey = @"CLLPickerDateDay";
NSString * const CLLPickerDateSelectedHourKey = @"CLLPickerDateHour";
NSString * const CLLPickerDateSelectedMinuteKey = @"CLLPickerDateMinute";
NSString * const CLLPickerDateSelectedSecondKey = @"CLLPickerDateSecond";

- (NSDictionary<CLLPickerDateSelectedKey,NSNumber *> *)selectedValueDictionary {
	return @{CLLPickerDateSelectedYearKey:@(_year.selectedData),CLLPickerDateSelectedMonthKey:@(_month.selectedData),CLLPickerDateSelectedDayKey:@(_day.selectedData),CLLPickerDateSelectedHourKey:@(_hour.selectedData),CLLPickerDateSelectedMinuteKey:@(_minute.selectedData),CLLPickerDateSelectedSecondKey:@(_second.selectedData)};
}

- (UIView *)bgView {
	if (!_bgView) {
		_bgView = [[UIView alloc] initWithFrame:kScreenRect];
	}
	return _bgView;
}
@end

#pragma mark - ------------- 分类 --------------
@implementation NSDate (CLLPickerDate)
- (NSDateComponents *)cll_components {
	NSDateComponents *components = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(NSStringFromSelector(_cmd)));
	if (!components) {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		components = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond fromDate:self];
		objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(NSStringFromSelector(_cmd)), components, OBJC_ASSOCIATION_RETAIN);
	}
	return components;
}

- (NSInteger)cll_year {
	return [self cll_components].year;
}

- (NSInteger)cll_month {
	return [self cll_components].month;
}

- (NSInteger)cll_day {
	return [self cll_components].day;
}

- (NSInteger)cll_hour {
	return [self cll_components].hour;
}

- (NSInteger)cll_minute {
	return [self cll_components].minute;
}

- (NSInteger)cll_second {
	return [self cll_components].second;
}

- (NSInteger)cll_daysInMonth {
	NSCalendar * calendar = [NSCalendar currentCalendar];
	// 调用rangeOfUnit方法:(返回一样是一个结构体)两个参数一个大单位，一个小单位(.length就是天数，.location就是月)
	NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
	return monthNum;
}

- (NSDate *)cll_dateWithYear:(NSInteger)year month:(NSInteger)month {
	return [self cll_dateWithYear:year month:month day:0 hour:0 minute:0 second:0];
}

- (NSDate *)cll_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *com = [self cll_components];
	NSDate *date = [calendar dateWithEra:com.era year:year?year:com.year month:month?month:com.month day:day?day:com.day hour:hour?hour:com.hour minute:minute?minute:com.minute second:second?second:com.second nanosecond:com.nanosecond];
	return date;
}

- (NSDate *)cll_dateWithPickerValueDictionary:(NSDictionary<CLLPickerDateSelectedKey,NSNumber *> *)dic {
	return [self cll_dateWithYear:dic[CLLPickerDateSelectedYearKey].integerValue month:dic[CLLPickerDateSelectedMonthKey].integerValue day:dic[CLLPickerDateSelectedDayKey].integerValue hour:dic[CLLPickerDateSelectedHourKey].integerValue minute:dic[CLLPickerDateSelectedMinuteKey].integerValue second:dic[CLLPickerDateSelectedSecondKey].integerValue];
}

@end
