//
//  UILabel+CLLFrame.m
//  CLLPickerDateDemo
//
//  Created by leocll on 2017/9/6.
//  Copyright © 2017年 leocll. All rights reserved.
//

#import "UIView+CLLFrame.h"

CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (CLLFrame)

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint {
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)aSize {
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

- (CGPoint)bottomRight {
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint)bottomLeft {
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint)topRight {
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight {
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth {
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat)top {
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop {
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat)left {
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft {
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom {
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright {
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

- (void)cll_moveBy:(CGPoint)var {
	CGPoint newcenter = self.center;
	newcenter.x += var.x;
	newcenter.y += var.y;
	self.center = newcenter;
}

- (void)cll_scaleBy:(CGFloat)scale {
	CGRect newframe = self.frame;
	newframe.size.width *= scale;
	newframe.size.height *= scale;
	self.frame = newframe;
}

- (void)cll_fitInSize:(CGSize)aSize {
	CGFloat scale;
	CGRect newframe = self.frame;
	if (newframe.size.height && (newframe.size.height > aSize.height)) {
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	if (newframe.size.width && (newframe.size.width >= aSize.width)) {
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
    }
	self.frame = newframe;	
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end
