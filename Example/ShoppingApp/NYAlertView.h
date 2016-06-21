/*
 * Copyright 2015-2016 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NYAlertViewButtonType) {
    NYAlertViewButtonTypeFilled,
    NYAlertViewButtonTypeBordered
};

@interface UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end

@interface NYAlertViewButton : UIButton

@property (nonatomic) NYAlertViewButtonType type;

@property (nonatomic) CGFloat cornerRadius;

@end

@interface NYAlertView : UIView

@property UILabel *titleLabel;
@property UITextView *messageTextView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UIFont *buttonTitleFont;
@property (nonatomic) UIFont *cancelButtonTitleFont;
@property (nonatomic) UIFont *destructiveButtonTitleFont;

@property (nonatomic) UIColor *buttonColor;
@property (nonatomic) UIColor *buttonTitleColor;
@property (nonatomic) UIColor *cancelButtonColor;
@property (nonatomic) UIColor *cancelButtonTitleColor;
@property (nonatomic) UIColor *destructiveButtonColor;
@property (nonatomic) UIColor *destructiveButtonTitleColor;

@property (nonatomic) CGFloat buttonCornerRadius;
@property (nonatomic) CGFloat maximumWidth;

@property (nonatomic, readonly) UIView *alertBackgroundView;

@property (nonatomic, readonly) NSLayoutConstraint *backgroundViewVerticalCenteringConstraint;

//@property (nonatomic) NSArray *actions;
@property (nonatomic) NSArray *actionButtons;

@property (nonatomic) NSArray *textFields;

@end
