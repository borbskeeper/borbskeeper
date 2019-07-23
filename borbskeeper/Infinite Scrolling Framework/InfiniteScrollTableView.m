//
//  InfiniteScrollTableView.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/23/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollTableView.h"

@implementation InfiniteScrollTableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.bounds.size.height;
        
        if(self.contentOffset.y > scrollOffsetThreshold && self.isDragging) {
            self.isMoreDataLoading = true;
            [self.infScrollTableDelegate loadMoreDataWithCompletion:^(NSError * error) {
                self.isMoreDataLoading = false;
            }];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
