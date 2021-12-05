#include <substrate.h>
#import <SpringBoard/SpringBoard.h>

#import "GcUniversal/GcColorPickerUtils.h"


@interface SBFLockScreenDateView: UIView
@property (nonatomic, strong, readwrite) NSDate* date;
-(void) _updateUsesCompactDateFormat;

@end

@interface SBFLockScreenDateViewController: UIViewController
-(void) updateCustomTime;
@end


@interface SBFLockScreenDateSubtitleDateView: UIView
@end

// Battery View

@interface SBFTouchPassThroughView : UIView
@end

@interface CSCoverSheetViewBase : SBFTouchPassThroughView
@end

@interface CSBatteryChargingView : CSCoverSheetViewBase
-(void)setBatteryVisible:(BOOL)arg1 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void) viewDidDisappear;
- (void)removeFromSuperview;
@end

static bool CREATED=NO;
static NSString* fontName = @"Helvetica";
static UILabel* l = nil;

static NSTimer* timer;

static dispatch_source_t dispatchSource;

static UIColor* hourColor;
static UIColor* minuteColor;
static UIColor* secondsColor;


// If anyone can figure out how to get attributed string colours working on SBUILegibility labels, I'd be eternally grateful
// So in the mean time, I am just using my own UILabel.

%hook SBFLockScreenDateViewController
-(void) viewDidLoad
{
	
	hourColor = [GcColorPickerUtils colorFromDefaults:@"com.skrypton.timeprefbundle" withKey:@"hourColor"];
    minuteColor = [GcColorPickerUtils colorFromDefaults:@"com.skrypton.timeprefbundle" withKey:@"minuteColor"];
    secondsColor = [GcColorPickerUtils colorFromDefaults:@"com.skrypton.timeprefbundle" withKey:@"secondsColor"];
	
	//hourColor = [UIColor whiteColor];
	//minuteColor = [UIColor whiteColor];
	//secondsColor = [UIColor whiteColor];
	if (!CREATED)
	{
		l = [[UILabel alloc] initWithFrame: CGRectMake(0,0,1,1)];
		[self.view addSubview: l];
		l.textColor = [UIColor whiteColor];
		CREATED=YES;
	}
	
	self.view.subviews[0].hidden = YES;

	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
    target:self
    selector:@selector(updateCustomTime)
    userInfo:nil
    repeats:YES];

	[[NSRunLoop currentRunLoop] addTimer: timer 
                             forMode:NSRunLoopCommonModes];
}

%new
-(void) updateCustomTime
{
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

	[dateFormat setDateFormat: @"hh:mm:ss"];
	NSString* dateText = [dateFormat stringFromDate: date];

	if (!l) return;
	if (!dateText)
	{
		return;
	}

	NSMutableAttributedString* dateAttText = [[NSMutableAttributedString alloc] initWithString:dateText];

	[dateAttText addAttribute:NSForegroundColorAttributeName 
             value:hourColor
             range:NSMakeRange(0, 2)];

	[dateAttText addAttribute:NSForegroundColorAttributeName 
             value:minuteColor
             range:NSMakeRange(3, 2)];

	[dateAttText addAttribute:NSForegroundColorAttributeName 
             value:secondsColor
             range:NSMakeRange(6, 2)];
	
	[l setFont:[UIFont fontWithName:fontName size:70 ]];
	[l setAttributedText: dateAttText];
	[l sizeToFit];

}
%end

%hook SBFLockScreenDateView


-(void) layoutSubviews
{
	%orig;
	UIView* view = self.subviews[0];
	UIView* subtitles = self.subviews[1];
	//UILabel* dateLabel = self.subviews[0].subviews[0];

	view.frame = CGRectMake(0,view.frame.origin.y,view.frame.size.width,view.frame.size.height);	
	subtitles.frame = CGRectMake(0,subtitles.frame.origin.y,subtitles.frame.size.width,subtitles.frame.size.height);

}

%end

%ctor {


}


// Make custom clock disappear when battery icon appears

%hook CSBatteryChargingView

-(id)initWithFrame:(CGRect)arg1 
{
	if (l) [l setAlpha: 0.0];
	return %orig;
}

- (void)removeFromSuperview
{
	%orig;
	if (l) [l setAlpha:1.0];
}

%end