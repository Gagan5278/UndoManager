//
//  DraggableView.h
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView
{
    //Bool Vars used to handle touch on four coreners on drawn View
    BOOL isResizingFromLeftRIght;
    BOOL isResizingFromUnderLeft;
    BOOL isResizingFromUnderRight;
    BOOL isResizingFromLowerLeft;
    
    BOOL isMovingView;

    
    CGPoint startLocation;                     //Start Touch point for a view
}

@property CGRect initialRect;

@end
