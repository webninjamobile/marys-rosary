//
//  MZTransition.h
//  MZFormSheetController
//
//  Created by Michał Zaborowski on 21.12.2013.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

@import UIKit;

extern NSString *const __nonnull MZTransitionExceptionMethodNotImplemented;

typedef void (^MZTransitionCompletionHandler)();

@class MZFormSheetPresentationController;

typedef NS_ENUM(NSInteger, MZFormSheetPresentationTransitionStyle) {
  MZFormSheetPresentationTransitionStyleSlideFromTop = 0,
  MZFormSheetPresentationTransitionStyleSlideFromBottom,
  MZFormSheetPresentationTransitionStyleSlideFromLeft,
  MZFormSheetPresentationTransitionStyleSlideFromRight,
  MZFormSheetPresentationTransitionStylelideAndBounceFromLeft,
  MZFormSheetPresentationTransitionStyleSlideAndBounceFromRight,
  MZFormSheetPresentationTransitionStyleFade,
  MZFormSheetPresentationTransitionStyleBounce,
  MZFormSheetPresentationTransitionStyleDropDown,
  MZFormSheetPresentationTransitionStyleCustom,
  MZFormSheetPresentationTransitionStyleNone,
};

@protocol MZFormSheetPresentationControllerTransitionProtocol <NSObject>
@required
/**
 Subclasses must implement to add custom transition animation.
 When animation is finished you must call super method or completionHandler to
 keep view life cycle.
 */
- (void)entryFormSheetControllerTransition:(nonnull MZFormSheetPresentationController *)formSheetController
                         completionHandler:(nonnull MZTransitionCompletionHandler)completionHandler;

- (void)exitFormSheetControllerTransition:(nonnull MZFormSheetPresentationController *)formSheetController
                        completionHandler:(nonnull MZTransitionCompletionHandler)completionHandler;

@end

@interface MZTransition
    : NSObject <MZFormSheetPresentationControllerTransitionProtocol>

@end
