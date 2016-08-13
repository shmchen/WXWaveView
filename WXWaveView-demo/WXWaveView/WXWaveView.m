//
//  WXWaveView.m
//
//  Created by WelkinXie on 16/4/20.
//  Copyright © 2016年 WelkinXie. All rights reserved.
//
//  Github: https://github.com/WelkinXie/WXWaveView
//

#import "WXWaveView.h"

@interface WXWaveView ()

@property (assign, nonatomic) CGFloat offsetX;
@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;

@end

@implementation WXWaveView

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    WXWaveView *waveView = [[self alloc] initWithFrame:frame];
    [view addSubview:waveView];
    return waveView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self basicSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self basicSetup];
    }
    return self;
}

- (void)basicSetup {
    _waveSpeed = 3.f;
    _waveTime = 1.f;
    _waveColor = [UIColor whiteColor];
}

- (BOOL)wave {
    
    if (self.waveShapeLayer.path) {
        return NO;
    }
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (self.waveTime > 0.f) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waveTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stop];
        });
    }
    return YES;
}

- (void)getCurrentWave {
    
    self.offsetX += self.waveSpeed;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(self.frame) / 2);

    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= CGRectGetWidth(self.frame) ; x++) {
        y = CGRectGetHeight(self.frame) * sin((10 / CGRectGetWidth(self.frame)) * x - self.offsetX * 0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    CGPathCloseSubpath(path);
    
    self.waveShapeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)stop {
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.waveDisplayLink invalidate];
        self.waveDisplayLink = nil;
        self.waveShapeLayer.path = nil;
        self.alpha = 1.f;
    }];
    
}

@end
