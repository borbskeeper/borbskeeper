//
//  InfiniteScrollView.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/24/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

@implementation InfiniteScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    if ((self.tableView.delegate == nil) || (self.tableView.dataSource == nil)){
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        NSLog(@"Laying out subviews!");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.infiniteScrollDelegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.infiniteScrollDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(self.tableView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self.infiniteScrollDelegate loadMoreData];
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
