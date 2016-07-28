//
//  UMComUserCommentViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/19/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimplicityRequestTableViewController.h"

@protocol UMComFeedClickActionDelegate;

@interface UMComSimpleSubCommentViewController : UMComSimplicityRequestTableViewController

@property (nonatomic, weak) id<UMComFeedClickActionDelegate> delegate;

@end
