//
//  ViewController.m
//  PiktochartTest
//
//  Created by Gagan5278 on 04/02/16.
//  Copyright © 2016 Gagan5278. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"
#import "UIColor+HexColor.h"
//#import "RecordChange.h"

@interface ViewController ()<SelectedView>
{
    AppDelegate *objAppDel;  //AppDelegate Instance
    DraggableView *selectedView;  //Current selected SubView on MainScreen
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objAppDel =[AppDelegate objectAppDelegate];
    objAppDel.touchViewDelegate=self;
    
    for (NSDictionary *dict in objAppDel.arrayOfRecord)
    {
        CGRect viewRectangle;
        viewRectangle.origin.x =[[dict valueForKey:viewX] floatValue];
        viewRectangle.origin.y =[[dict valueForKey:viewY] floatValue];
        viewRectangle.size.height =[[dict valueForKey:viewHeight] floatValue];
        viewRectangle.size.width =[[dict valueForKey:viewWidth] floatValue];
        UIView *draggerView = [[DraggableView alloc] init] ;
        draggerView.tag =[[dict valueForKey:viewID] intValue];
        draggerView.backgroundColor= [UIColor getColorFromHexString:[dict valueForKey:@"color"]];
        [draggerView setUserInteractionEnabled:YES];
        
        [self setNewFrame:viewRectangle ofView:draggerView undoTransform:viewRectangle];
        
        //Move view by an angle on  long press with duration 1.0 seconds:----Additional Task. Not monitored by Undomanager
        UILongPressGestureRecognizer *longGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(rotateViewByAnAngle:)];
        longGesture.minimumPressDuration=1.0;
        [draggerView addGestureRecognizer:longGesture];
        longGesture=nil;
        
        [self.view addSubview:draggerView];
        draggerView=nil;
    }
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma -mark RotateView on Long press
-(void)rotateViewByAnAngle:(UIGestureRecognizer*)sender
{
    UIView *view =[sender view];

    CGAffineTransform newTransform = view.transform;
    view.transform = CGAffineTransformMakeScale(0.5,0.7);
    CGFloat scale = 2.0f;
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width*scale , view.frame.size.height*scale);
    view.transform = newTransform;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",view.tag];
    NSArray * filterdArray = [objAppDel.arrayOfRecord filteredArrayUsingPredicate:predicate];
    if(filterdArray.count>0)
    {
        NSMutableDictionary *dictionary = [filterdArray objectAtIndex:0];
        [dictionary setValue:NSStringFromCGAffineTransform(newTransform) forKey:@"tranfrom"];
    }
    [view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
- (void)setNewFrame:(CGRect)newFrame ofView:(UIView *)view   undoTransform:(CGRect)undoFrame
{
    [objAppDel.dictionaryOfRecord setValue:NSStringFromCGRect(undoFrame) forKey:[NSString stringWithFormat:@"%ld",view.tag]];
    [[self.undoManager prepareWithInvocationTarget:self]setNewFrame:undoFrame ofView:view undoTransform:newFrame];
    view.frame = newFrame;
}

-(void)getAndUpdateDictionaryFromArrayForView:(DraggableView*)view
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",view.tag];
    NSArray * filterdArray = [objAppDel.arrayOfRecord filteredArrayUsingPredicate:predicate];
    if(filterdArray.count>0)
    {
        CGRect viewRect = view.frame;
        NSMutableDictionary *dictionary = [filterdArray objectAtIndex:0];
        [dictionary setValue:[NSString stringWithFormat:@"%.2f",viewRect.size.width] forKey:viewWidth];
        [dictionary setValue:[NSString stringWithFormat:@"%.2f",viewRect.size.height] forKey:viewHeight];
        [dictionary setValue:[NSString stringWithFormat:@"%.2f",viewRect.origin.x] forKey:viewX];
        [dictionary setValue:[NSString stringWithFormat:@"%.2f",viewRect.origin.y] forKey:viewY];
    }
}

#pragma -mark UndoManager

//UndoManager Undo/Redo opertaions

- (IBAction)undoButtonTapped:(id)sender {
    if([self.undoManager canUndo])
    {
        [self.undoManager undo];
        [self getAndUpdateDictionaryFromArrayForView:selectedView];
    }
}

- (IBAction)redoButtonTapped:(id)sender {
    if([self.undoManager canRedo])
    {
        [self.undoManager redo];
        [self getAndUpdateDictionaryFromArrayForView:selectedView];
    }
}

#pragma -mark Save data in JSON fille
- (IBAction)saveInJsonFileButtonPressed:(id)sender {
    [[JSONParser sharedParserManager]saveInDocumentDirectory];   //Save in App document directory with name "JSONFile.json"
}

#pragma -mark: SelectedView
-(void)currentTouchView:(DraggableView*)view
{
    selectedView=view;
    [self setNewFrame:view.frame ofView:view undoTransform:view.initialRect];
    [self getAndUpdateDictionaryFromArrayForView:view];
}

//-(void)currentCenterOfView:(DraggableView*)view
//{
//    
//}

@end
