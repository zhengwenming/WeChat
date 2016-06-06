//
//  MMPlaceHolder.m
//  driving
//
//  Created by Ralph Li on 8/11/14.
//  Copyright (c) 2014 LJC. All rights reserved.
//

#import "MMPlaceHolder.h"
#import <objc/runtime.h>
@import QuartzCore;

@interface  MMPlaceHolderConfig()

@property (nonatomic, strong) NSArray *defaultMemberOfClasses;

@end

@implementation MMPlaceHolderConfig


- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.lineColor = [UIColor whiteColor];
        self.backColor = [UIColor clearColor];
        self.arrowSize = 3;
        self.lineWidth = 1;
        self.frameWidth = 0;
        self.frameColor = [UIColor redColor];
        
        self.showArrow = YES;
        self.showText = YES;
        
        self.visible = YES;
        self.autoDisplay = NO;
        self.visibleKindOfClasses = @[];
        self.visibleMemberOfClasses = @[];
        self.defaultMemberOfClasses = @[UIImageView.class,
                                        UIButton.class,
                                        UILabel.class,
                                        UITextField.class,
                                        UITextView.class,
                                        UISwitch.class,
                                        UISlider.class,
                                        UIPageControl.class];
    }
    
    return self;
}


- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    
    UIResponder<UIApplicationDelegate> *delegate = [UIApplication sharedApplication].delegate;
    
    if ( !visible )
    {
        [delegate.window hidePlaceHolderWithAllSubviews];
    }
    else
    {
        [delegate.window showPlaceHolderWithAllSubviews];
    }
}

+ (MMPlaceHolderConfig *)defaultConfig
{
    static dispatch_once_t  onceQueue;
    static MMPlaceHolderConfig *appInstance;
    
    dispatch_once(&onceQueue, ^{
        appInstance = [[MMPlaceHolderConfig alloc] init];
    });
    return appInstance;
}

@end

@interface MMPlaceHolder()


@end

@implementation MMPlaceHolder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.userInteractionEnabled = NO;
        
        self.lineColor  = [MMPlaceHolderConfig defaultConfig].lineColor;
        self.backColor  = [MMPlaceHolderConfig defaultConfig].backColor;
        self.arrowSize  = [MMPlaceHolderConfig defaultConfig].arrowSize;
        self.lineWidth  = [MMPlaceHolderConfig defaultConfig].lineWidth;
        self.frameColor = [MMPlaceHolderConfig defaultConfig].frameColor;
        self.frameWidth = [MMPlaceHolderConfig defaultConfig].frameWidth;
        
        self.showArrow = [MMPlaceHolderConfig defaultConfig].showArrow;
        self.showText = [MMPlaceHolderConfig defaultConfig].showText;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat fontSize = 4 + (MIN(width,height))/10;
    CGFloat arrowSize = self.arrowSize;
    CGFloat lineWidth = self.lineWidth;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    //fill the back
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextFillRect(ctx, rect);
    
    // strike frame
    if ( self.frameWidth > 0 )
    {
        CGFloat radius = self.frameWidth/2;
        
        CGContextSetLineWidth(ctx, self.frameWidth);
        CGContextSetStrokeColorWithColor(ctx, self.frameColor.CGColor);
        
        CGContextMoveToPoint(ctx, radius, radius);
        CGContextAddLineToPoint(ctx, radius, height - radius);
        CGContextAddLineToPoint(ctx, width - radius, height - radius);
        CGContextAddLineToPoint(ctx, width - radius, radius);
        CGContextAddLineToPoint(ctx, radius, radius);
        CGContextClosePath(ctx);
        
        CGContextStrokePath(ctx);
    }

    if ( self.showArrow )
    {
        //strike lines & arrows
        CGFloat radius = self.frameWidth/2*3;
        
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2, height-radius);
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2 - arrowSize, arrowSize + radius);
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2 + arrowSize, arrowSize + radius);
        CGContextMoveToPoint(ctx, width/2, height-radius);
        CGContextAddLineToPoint(ctx, width/2 - arrowSize, height - arrowSize - radius);
        CGContextMoveToPoint(ctx, width/2, height-radius);
        CGContextAddLineToPoint(ctx, width/2 + arrowSize, height - arrowSize - radius);
        
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, width - radius, height/2);
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 - arrowSize);
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 + arrowSize);
        CGContextMoveToPoint(ctx, width - radius, height/2);
        CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 - arrowSize);
        CGContextMoveToPoint(ctx, width - radius, height/2);
        CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 + arrowSize);
        
        CGContextStrokePath(ctx);
    }
    
    if ( self.showText )
    {
        //calculate the text area
        NSString *text = [NSString stringWithFormat:@"%.0f X %.0f",width, height];
        
        NSDictionary *textFontAttributes = @{
                                             NSFontAttributeName: font,
                                             NSForegroundColorAttributeName: self.lineColor
                                             };
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:textFontAttributes context:nil].size;
        
        CGFloat rectWidth = ceilf(textSize.width)+4;
        CGFloat rectHeight = ceilf(textSize.height)+4;
        
        //clear the area behind the textz
        CGRect textRect = CGRectMake(width/2-rectWidth/2, height/2-rectHeight/2, rectWidth, rectHeight);
        CGContextClearRect(ctx, textRect);
        CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
        CGContextFillRect(ctx, textRect);
        
        //draw text
        CGContextSetFillColorWithColor(ctx, self.lineColor.CGColor);
        [text drawInRect:CGRectInset(textRect, 0, 2) withAttributes:textFontAttributes];
    }
}


@end


@implementation UIView(MMPlaceHolder)

- (void)didMoveToSuperview
{
    [self checkAutoDisplay];
}

- (void)checkAutoDisplay
{
    if ( self.class != [MMPlaceHolder class] )
    {
        if ( [MMPlaceHolderConfig defaultConfig].autoDisplay )
        {
            //means self is a system bundle view
            if ( [NSBundle bundleForClass:[UIView class]] == [NSBundle bundleForClass:[self class]] )
            {
                if ( ![MMPlaceHolderConfig defaultConfig].autoDisplaySystemView ) {
                    
                    //skip if self is not in the white list
                    if ( ![[MMPlaceHolderConfig defaultConfig].defaultMemberOfClasses containsObject:self.class] )
                    {
                        return;
                    }
                }
            }
            
            if ([MMPlaceHolderConfig defaultConfig].visibleMemberOfClasses.count>0)
            {
                for ( Class cls in [MMPlaceHolderConfig defaultConfig].visibleMemberOfClasses )
                {
                    if ( [self isMemberOfClass:cls] )
                    {
                        [self showPlaceHolder];
                        
                        return;
                    }
                }
            }
            else if ([MMPlaceHolderConfig defaultConfig].visibleKindOfClasses.count>0)
            {
                for ( Class cls in [MMPlaceHolderConfig defaultConfig].visibleKindOfClasses )
                {
                    if ( [self isKindOfClass:cls] )
                    {
                        [self showPlaceHolder];
                        
                        return;
                    }
                }
            }
            else
            {
                [self showPlaceHolder];
                
            }
        }
    }
}


- (void)showPlaceHolder
{
    [self showPlaceHolderWithLineColor:[MMPlaceHolderConfig defaultConfig].lineColor];
}

- (void)showPlaceHolderWithAllSubviews
{
    [self showPlaceHolderWithAllSubviews:NSIntegerMax];
}

- (void)showPlaceHolderWithAllSubviews:(NSInteger)maxDepth
{
    if ( maxDepth > 0 )
    {
        for ( UIView *v in self.subviews )
        {
            [v showPlaceHolderWithAllSubviews:maxDepth-1];
        }
    }
    
    [self showPlaceHolder];
}

- (void)showPlaceHolderWithLineColor:(UIColor *)lineColor
{
    [self showPlaceHolderWithLineColor:lineColor backColor:[MMPlaceHolderConfig defaultConfig].backColor];
}

- (void)showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor
{
    [self showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:[MMPlaceHolderConfig defaultConfig].arrowSize];
}


- (void)showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize
{
    [self showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:arrowSize lineWidth:[MMPlaceHolderConfig defaultConfig].lineWidth];
}


- (void)showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth
{
    
    [self showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:arrowSize lineWidth:[MMPlaceHolderConfig defaultConfig].lineWidth frameWidth:[MMPlaceHolderConfig defaultConfig].frameWidth frameColor:[MMPlaceHolderConfig defaultConfig].frameColor];
}

- (void)showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth frameWidth:(CGFloat)frameWidth frameColor:(UIColor *)frameColor
{
    NSLog(@"%@",NSStringFromClass(self.class));
#if RELEASE
    
#else
    
    MMPlaceHolder *placeHolder = [self getPlaceHolder];
    
    if ( !placeHolder )
    {
        placeHolder = [[MMPlaceHolder alloc] initWithFrame:self.bounds];
        
        placeHolder.tag = [NSStringFromClass([MMPlaceHolder class]) hash]+(NSInteger)self;
        
        [self addSubview:placeHolder];
    }
    
    placeHolder.lineColor  = lineColor;
    placeHolder.backColor  = backColor;
    placeHolder.arrowSize  = arrowSize;
    placeHolder.lineWidth  = lineWidth;
    placeHolder.frameColor = frameColor;
    placeHolder.frameWidth = frameWidth;
    placeHolder.hidden = ![MMPlaceHolderConfig defaultConfig].visible;
    
    
#endif
}

- (void)hidePlaceHolder
{
    MMPlaceHolder *placeHolder = [self getPlaceHolder];
    
    if ( placeHolder )
    {
        placeHolder.hidden = YES;
    }
}

- (void)hidePlaceHolderWithAllSubviews
{
    for ( UIView *v in self.subviews )
    {
        [v hidePlaceHolderWithAllSubviews];
    }
    
    [self hidePlaceHolder];
}

- (void)removePlaceHolder
{
    MMPlaceHolder *placeHolder = [self getPlaceHolder];
    
    if ( placeHolder )
    {
        [placeHolder removeFromSuperview];
    }
}

- (void)removePlaceHolderWithAllSubviews
{
    for ( UIView *v in self.subviews )
    {
        [v removePlaceHolderWithAllSubviews];
    }
    
    [self removePlaceHolder];
}


- (MMPlaceHolder *)getPlaceHolder
{
    return (MMPlaceHolder*)[self viewWithTag:[NSStringFromClass([MMPlaceHolder class]) hash]+(NSInteger)self];
}

@end
