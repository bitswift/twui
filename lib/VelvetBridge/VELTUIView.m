//
//  VELTUIView.m
//  Velvet
//
//  Created by Josh Vera on 11/21/11.
//  Copyright (c) 2011 Bitswift. All rights reserved.
//

#import "VELTUIView.h"
#import "TUIView.h"
#import "TUIView+VELBridgedViewAdditions.h"

@interface VELView (ProtectedMethodsFixup)
// TODO: expose this!
- (void)didMoveFromHostView:(id<VELHostView>)oldHostView;
@end

@implementation VELTUIView

#pragma mark Properties

@synthesize guestView = m_guestView;

- (void)setGuestView:(TUIView *)view {
    [m_guestView.layer removeFromSuperlayer];
    m_guestView.nsView = nil;
    m_guestView.hostView = nil;

    m_guestView = view;

    if (m_guestView) {
        m_guestView.nsView = self.ancestorNSVelvetView;
        m_guestView.hostView = self;
        m_guestView.nextResponder = self;

        [self.layer addSublayer:m_guestView.layer];
    }
}

#pragma mark Lifecycle

- (id)initWithTUIView:(TUIView *)view {
	self = [super init];
	if (!self)
		return nil;

	self.guestView = view;
	return self;
}

#pragma mark View hierarchy

- (void)didMoveFromHostView:(id<VELHostView>)oldHostView {
    [super didMoveFromHostView:oldHostView];

    self.guestView.nsView = self.ancestorNSVelvetView;
}

- (id<VELBridgedView>)descendantViewAtPoint:(CGPoint)point {
    CGPoint viewPoint = [self.guestView.layer convertPoint:point fromLayer:self.layer];
    return [self.guestView descendantViewAtPoint:viewPoint];
}

#pragma mark NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> frame = %@, TUIView = %@ %@", [self class], self, NSStringFromRect(self.frame), self.guestView, NSStringFromRect(self.guestView.frame)];
}

@end
