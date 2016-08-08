//
//  UMComConstraintCache.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/26/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComConstraintCache.h"
#import "UMComKit+Autolayout.h"


@implementation UMComConstraintCache

- (instancetype)init
{
    if (self = [super init]) {
        self.constraints = [NSMutableArray array];
        self.superConstraints = [NSMutableArray array];
    }
    return self;
}

@end



@implementation UMComConstraintCacheManager

- (instancetype)init
{
    if (self = [super init]) {
        self.cacheContainer = [NSMutableDictionary dictionary];
        _alwaysCache = YES;
    }
    return self;
}

- (BOOL)cacheViewConstraints:(UIView *)view forKey:(NSString *)key
{
    if (!key || !view) {
        // log
        return NO;
    }
    //    NSLog(@"%ld", _cacheContainer.count);
    if (_alwaysCache && _cacheContainer[key]) {
        return YES;
    }
    
    UMComConstraintCache *cache = [[UMComConstraintCache alloc] init];
    cache.view = view;
    cache.superView = view.superview;
    cache.constraints = view.constraints;
    cache.superConstraints = [UMComKit ALView_AllConstraints:view];
    cache.subviewsCache = [self recursiveCacheConstraintsOfSubviews:view];
    
    [_cacheContainer setObject:cache forKey:key];
    return YES;
}

- (NSArray<UMComConstraintCache *> *)recursiveCacheConstraintsOfSubviews:(UIView *)view
{
    if (view.subviews.count == 0) {
        return nil;
    }
    NSMutableArray *cacheList = [NSMutableArray array];
    for (UIView *v in view.subviews) {
        UMComConstraintCache *cache = [[UMComConstraintCache alloc] init];
        cache.view = v;
        cache.constraints = v.constraints;
        cache.subviewsCache = [self recursiveCacheConstraintsOfSubviews:v];
        [cacheList addObject:cache];
    }
    return cacheList;
}

- (BOOL)restoreViewConstraintsToSuperView:(UIView *)view forKey:(NSString *)key
{
    // the view has already in super view's hierarchy
    if ([view superview]) {
        return YES;
    }
    
    UMComConstraintCache *cache = _cacheContainer[key];
    if (!cache) {
        // error: UMComConstraintCacheManager -> no constraints cache here!
        return NO;
    }
    
    if (!cache.view) {
        // error: UMComConstraintCacheManager -> invalid view!
        return NO;
    }
    if (!cache.superView) {
        // error: UMComConstraintCacheManager -> invalid super view!
        return NO;
    }
    
    [cache.superView addSubview:cache.view];
    [cache.view addConstraints:cache.constraints];
    [cache.superView addConstraints:cache.superConstraints];
    [self recursiveRestoreSubviewsConstraints:cache.subviewsCache];
    
    if (!_alwaysCache) {
        [_cacheContainer removeObjectForKey:key];
    }
    
    return YES;
}

- (void)recursiveRestoreSubviewsConstraints:(NSArray<UMComConstraintCache *> *)cacheList
{
    for (UMComConstraintCache *cache in cacheList) {
        [cache.view addConstraints:cache.constraints];
        [self recursiveRestoreSubviewsConstraints:cache.subviewsCache];
    }
}

@end