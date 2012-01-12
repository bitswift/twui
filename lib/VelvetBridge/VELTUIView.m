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
#import "TUIView+VELTUIViewAdditions.h"

@interface VELView (ProtectedMethodsFixup)
// TODO: expose this!
- (void)didMoveFromHostView:(NSVelvetView *)oldHostView;
@end

@implementation VELTUIView

#pragma mark Properties

@synthesize TUIView = m_TUIView;

- (void)setTUIView:(TUIView *)view {
    [m_TUIView.layer removeFromSuperlayer];
    m_TUIView.nsView = nil;
    m_TUIView.hostView = nil;

    m_TUIView = view;

    if (m_TUIView) {
        m_TUIView.nsView = self.hostView;
        m_TUIView.hostView = self;
        m_TUIView.nextResponder = self;

        [self.layer addSublayer:m_TUIView.layer];
    }
}

#pragma mark Lifecycle

- (id)initWithTUIView:(TUIView *)view {
	self = [super init];
	if (!self)
		return nil;

	self.TUIView = view;
	return self;
}

#pragma mark View hierarchy

- (void)didMoveFromHostView:(NSVelvetView *)oldHostView {
    [super didMoveFromHostView:oldHostView];

    self.TUIView.nsView = self.hostView;
}

- (id<VELBridgedView>)descendantViewAtPoint:(CGPoint)point {
    CGPoint viewPoint = [self.TUIView.layer convertPoint:point fromLayer:self.layer];
    return [self.TUIView descendantViewAtPoint:viewPoint];
}

#pragma mark NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> frame = %@, TUIView = %@", [self class], self, NSStringFromRect(self.frame), self.TUIView];
}

@end
