//
//  DTLinkButton.m
//  CoreTextExtensions
//
//  Created by Oliver Drobnik on 1/16/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//

#import "DTLinkButton.h"
#import "CGUtils.h"
#import "DTColor+HTML.h"

// constant for notification
NSString *DTLinkButtonDidHighlightNotification = @"DTLinkButtonDidHighlightNotification";


@interface DTLinkButton ()

- (void)highlightNotification:(NSNotification *)notification;

@end


@implementation DTLinkButton
{
	NSURL *_URL;
    NSString *_GUID;
	
	CGSize _minimumHitSize;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.userInteractionEnabled = YES;
		self.enabled = YES;
		self.opaque = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highlightNotification:) name:DTLinkButtonDidHighlightNotification object:nil];
	}
	
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	if (self.highlighted)
	{
		CGRect imageRect = [self contentRectForBounds:self.bounds];
		
		UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:3.0f];
		CGContextSetGrayFillColor(ctx, 0.73f, 0.4f);
		[roundedPath fill];							 
	}
}

- (void)adjustBoundsIfNecessary
{
	CGRect bounds = self.bounds;
	CGFloat widthExtend = 0;
	CGFloat heightExtend = 0;
	
	if (bounds.size.width < _minimumHitSize.width)
	{
		widthExtend = _minimumHitSize.width - bounds.size.width;
		bounds.size.width = _minimumHitSize.width;
	}
	
	if (bounds.size.height < _minimumHitSize.height)
	{
		heightExtend = _minimumHitSize.height - bounds.size.height;
		bounds.size.height = _minimumHitSize.height;
	}
	
	if (widthExtend>0 || heightExtend>0)
	{
		self.contentEdgeInsets = UIEdgeInsetsMake(heightExtend/2.0f, widthExtend/2.0f, heightExtend/2.0f, widthExtend/2.0f);
		self.bounds = bounds;
	}
	else
	{
		self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	}
}

#pragma mark Notifications
- (void)highlightNotification:(NSNotification *)notification
{
	if ([notification object] == self)
	{
		// that was me
		return;
	}
	
	NSDictionary *userInfo = [notification userInfo];
	
	NSString *guid = [userInfo objectForKey:@"GUID"];
	
	if ([guid isEqualToString:_GUID])
	{
		BOOL highlighted = [[userInfo objectForKey:@"Highlighted"] boolValue];
		[super setHighlighted:highlighted];
		[self setNeedsDisplay];
	}
}



#pragma mark Properties

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
	
	
	// notify other parts of the same link
	if (_GUID)
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:highlighted], @"Highlighted", _GUID, @"GUID", nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:DTLinkButtonDidHighlightNotification object:self userInfo:userInfo];
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if (CGRectIsEmpty(frame))
	{
		return;
	}
	
	[self adjustBoundsIfNecessary];
}


- (void)setMinimumHitSize:(CGSize)minimumHitSize
{
	if (CGSizeEqualToSize(_minimumHitSize, minimumHitSize))
	{
		return;
	}
	
	_minimumHitSize = minimumHitSize;
	
	[self adjustBoundsIfNecessary];
	
}

@synthesize URL = _URL;
@synthesize GUID = _GUID;

@synthesize minimumHitSize = _minimumHitSize;



@end
