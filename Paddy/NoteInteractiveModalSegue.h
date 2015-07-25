//
//  NoteInteractiveModalSegue.h
//  Paddy
//
//  Created by Jian Jie on 24/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNote.h"

@protocol NoteInteractiveModalSegueDelgate;

@interface NoteInteractiveModalSegue : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, weak) id<NoteInteractiveModalSegueDelgate> deleteDelegate;
@property (nonatomic, strong) PDNote *note;
@property (nonatomic) bool interactive;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@protocol NoteInteractiveModalSegueDelgate <NSObject>

- (void)transitionControllerInteractionDidStart:(NoteInteractiveModalSegue *)transitionController;

@end