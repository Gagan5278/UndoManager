//
//  DraggableView.m
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import "DraggableView.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
CGFloat kResizeBorderSize = 15.0f;


@implementation DraggableView

-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if(self )
    {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //Draw sqaures on four corner of View for resizing option
    
    CGRect topLeftRect = CGRectMake(0, 0, kResizeBorderSize, kResizeBorderSize);
    [[UIColor grayColor] setFill];
    UIRectFill( topLeftRect );
    
    CGRect topRightRect = CGRectMake( self.frame.size.width-kResizeBorderSize,0, kResizeBorderSize, kResizeBorderSize);
    [[UIColor darkGrayColor] setFill];
    UIRectFill( topRightRect );
    
    CGRect topLowerLeftRect = CGRectMake(0, self.frame.size.height-kResizeBorderSize, kResizeBorderSize, kResizeBorderSize);
    [[UIColor darkGrayColor] setFill];
    UIRectFill( topLowerLeftRect );
    
    CGRect topLowerRightRect = CGRectMake(self.frame.size.width-kResizeBorderSize, self.frame.size.height-kResizeBorderSize, kResizeBorderSize, kResizeBorderSize);
    [[UIColor darkGrayColor] setFill];
    UIRectFill( topLowerRightRect );
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AppDelegate *objAppDel =(AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.initialRect =  CGRectFromString([objAppDel.dictionaryOfRecord valueForKey:[NSString stringWithFormat:@"%ld",self.tag]]); //self.frame;
    
    startLocation = [[touches anyObject] locationInView:self];
    isResizingFromLeftRIght = (self.bounds.size.width - startLocation.x < kResizeBorderSize && self.bounds.size.height - startLocation.y < kResizeBorderSize);
    isResizingFromUnderLeft = (startLocation.x <kResizeBorderSize && startLocation.y <kResizeBorderSize);
    isResizingFromUnderRight = (self.bounds.size.width-startLocation.x < kResizeBorderSize && startLocation.y<kResizeBorderSize);
    isResizingFromLowerLeft = (startLocation.x <kResizeBorderSize && self.bounds.size.height -startLocation.y <kResizeBorderSize);
    [[self superview] bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    // frame values to calculate changes
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (isResizingFromLeftRIght) {
        self.frame = CGRectMake(x, y, touchPoint.x+deltaWidth, touchPoint.y+deltaWidth);
    } else if (isResizingFromUnderLeft) {
        self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
    } else if (isResizingFromUnderRight) {
        self.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
    } else if (isResizingFromLowerLeft) {
        self.frame = CGRectMake(x+deltaWidth, y, width-deltaWidth, height+deltaHeight);
    } else {
        //dragging - move the view
        self.center = CGPointMake(self.center.x + touchPoint.x - startLocation.x, self.center.y + touchPoint.y - startLocation.y);
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AppDelegate *objAppDel =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(!isMovingView)
//    {
        [objAppDel.touchViewDelegate currentTouchView:self];
//    }
//    else{
//        //  [objAppDel.touchViewDelegate currentCenterOfView:self];
//    }
}

@end
