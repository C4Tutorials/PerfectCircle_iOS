//
//  C4WorkSpace.m
//  Examples
//
//  Created by Travis Kirton on 12-07-23.
//


#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)updateControlA;
@end

@implementation C4WorkSpace {
    C4Shape *triangle;
    CGPoint trianglePoints[3];
    //CGFloat pattern[2];
    C4Shape *controlA;
    CGRect triangleFrame;
}

-(void)setup {
    
    [C4Shape defaultStyle].fillColor = [UIColor blackColor];
    [C4Shape defaultStyle].strokeColor = [UIColor whiteColor];
    
    self.canvas.backgroundColor = [UIColor blackColor];
    
    triangle.strokeColor = [UIColor whiteColor];
    triangle.fillColor = [UIColor clearColor];
    
    trianglePoints[0] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);
    trianglePoints[1] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);
    trianglePoints[2] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);
    
    
    triangle = [C4Shape triangle:trianglePoints];
    
    //create 3 control shapes
    CGRect controlFrame = CGRectMake(0, 0, 22, 22);
    controlA = [C4Shape ellipse:controlFrame];
    controlA.fillColor = [UIColor blackColor];
    
    //move control shapes points to the coordinates of the curve control points
    
    
    CGFloat xOrigin = [C4Math minOfA:trianglePoints[0].x B:trianglePoints[1].x C:trianglePoints[2].x];
    CGFloat yOrigin = [C4Math minOfA:trianglePoints[0].y B:trianglePoints[1].y C:trianglePoints[2].y];
    
    triangleFrame = CGRectMake(xOrigin, yOrigin, triangle.bounds.size.width, triangle.bounds.size.height);
    
    [triangle setFrame:triangleFrame];
    
    [self.canvas addShape:triangle];
    [self.canvas addShape:controlA];
    
    //add drag gestures to the control shapes
    [controlA addGesture:PAN name:@"panGesture" action:@"move:"];
    //listen for when the control shapes are moved and update the curves as needed
    [self listenFor:@"moved" fromObject:controlA andRunMethod:@"updateControlA"];
    
    
    controlA.center = trianglePoints[0] ;
}




-(void)updateControlA {
    
    trianglePoints[0] = controlA.center;
    
    [triangle triangle:trianglePoints];
    
    [self makeNewTribounds];
    
    [triangle setFrame:triangleFrame];
    
}

-(void)makeNewTribounds {
    
    CGFloat xOrigin = [C4Math minOfA:trianglePoints[0].x B:trianglePoints[1].x C:trianglePoints[2].x];
    CGFloat yOrigin = [C4Math minOfA:trianglePoints[0].y B:trianglePoints[1].y C:trianglePoints[2].y];
    
    triangleFrame = CGRectMake(xOrigin, yOrigin, triangle.bounds.size.width, triangle.bounds.size.height);
}




@end
