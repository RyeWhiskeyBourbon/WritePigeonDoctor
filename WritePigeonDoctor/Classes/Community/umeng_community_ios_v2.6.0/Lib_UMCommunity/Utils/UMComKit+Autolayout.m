//
//  UMComKit+Autolayout.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/26/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit+Autolayout.h"

@implementation UMComKit (Autolayout)


+ (BOOL)ALView:(UIView *)view setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint * constraint = [UMComKit ALView:view constraintForAttribute:attribute];
    if(constraint)
    {
        [constraint setConstant:constant];
        return YES;
    }else
    {
        [view.superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:constant]];
        return NO;
    }
}


+ (CGFloat)ALView:(UIView *)view constraintConstantforAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint * constraint = [UMComKit ALView:view constraintForAttribute:attribute];
    
    if (constraint) {
        return constraint.constant;
    }else
    {
        return NAN;
    }
    
}

+ (NSArray *)ALView_AllConstraints:(UIView *)view
{
    NSMutableArray *constraints = [[view constraints] mutableCopy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ || secondItem = %@", view, view];
    NSArray *fillteredArray = [[view.superview constraints] filteredArrayUsingPredicate:predicate];
    [constraints addObjectsFromArray:fillteredArray];
    
    return constraints;
}

+ (NSLayoutConstraint*)ALView:(UIView *)view constraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", attribute, view];
    NSArray *fillteredArray = [[view.superview constraints] filteredArrayUsingPredicate:predicate];
    if(fillteredArray.count == 0) {
        fillteredArray = [[view constraints] filteredArrayUsingPredicate:predicate];
        if (fillteredArray.count == 0) {
            return nil;
        }
    }

    return fillteredArray.firstObject;
}


+ (void)ALView:(UIView *)view hideByHeight:(BOOL)hidden
{
    [UMComKit ALView:view hideView:hidden byAttribute:NSLayoutAttributeHeight];
}


+ (void)ALView:(UIView *)view hideByWidth:(BOOL)hidden
{
    [UMComKit ALView:view hideView:hidden byAttribute:NSLayoutAttributeWidth];
}



+ (void)ALView:(UIView *)view hideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute
{
    if (view.hidden != hidden) {
        CGFloat constraintConstant = [UMComKit ALView:view constraintConstantforAttribute:attribute];
        
        if (hidden)
        {
            
            if (!isnan(constraintConstant)) {
                view.alpha = constraintConstant;
            }else
            {
                CGSize size = [UMComKit ALView_GetSize:view];
                view.alpha = (attribute == NSLayoutAttributeHeight)?size.height:size.width;
            }
            
            [UMComKit ALView:view setConstraintConstant:0 forAttribute:attribute];
            view.hidden = YES;
            
        }else
        {
            if (!isnan(constraintConstant) ) {
                view.hidden = NO;
                [UMComKit ALView:view setConstraintConstant:view.alpha forAttribute:attribute];
                view.alpha = 1;
            }
        }
    }
}


+ (CGSize)ALView_GetSize:(UIView *)view
{
    [UMComKit ALView_UpdateSizes:view];
    return CGSizeMake(view.bounds.size.width, view.bounds.size.height);
}

+ (void)ALView_SizeToSubviews:(UIView *)view
{
    [UMComKit ALView_UpdateSizes:view];
    CGSize fittingSize = [view systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    view.frame = CGRectMake(0, 0, 320, fittingSize.height);
}

+ (void)ALView_UpdateSizes:(UIView *)view
{
    [view setNeedsLayout];
    [view layoutIfNeeded];
}


@end


