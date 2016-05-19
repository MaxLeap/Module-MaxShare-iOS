//
//  HorizontalCollectionViewLayout.h
//  MaxSocialShare
//
//  Created by Sun Jin on 4/5/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * CollectionViewLayout for an horizontal flow type:
 *
 *  |   0   1   |   6   7   |
 *  |   2   3   |   8   9   |   ----> etc...
 *  |   4   5   |   10  11  |
 *
 * Only supports 1 section and no headers, footers or decorator views.
 */
@interface MLSHorizontalPageCollectionViewLayout : UICollectionViewFlowLayout

@end
