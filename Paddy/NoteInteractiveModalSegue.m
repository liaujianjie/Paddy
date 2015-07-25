//
//  NoteInteractiveModalSegue.m
//  Paddy
//
//  Created by Jian Jie on 24/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NoteInteractiveModalSegue.h"

@implementation NoteInteractiveModalSegue

//- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
//{
//    self = [super initWithIdentifier:identifier source:source destination:destination];
//    if (self) {
////        _unwinding = NO;
////        _destinationRect = CGRectZero;
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (self) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] init];
        [_pinchGestureRecognizer addTarget:self action:@selector(handlePinchGesture:)];
    }
    return self;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
//    …
    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            [self.delegate transitionControllerInteractionDidStart:self];
            break;
        }
//            …
    }
}

- (void)perform
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

@end
