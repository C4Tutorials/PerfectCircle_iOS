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
    C4Shape *controlA, *hub1, *hub2;
    CGRect triangleFrame;
    NSInteger soften;
    
    CGContextRef graphicsContext;
    
    //UIImage *graphicsImage;
    UIImage *graphicsImage;
    
    
       
}

-(void)setup {
    
    [C4Shape defaultStyle].fillColor = [UIColor blackColor];
    [C4Shape defaultStyle].strokeColor = [UIColor whiteColor];
    
    soften = 6;
    
    self.canvas.backgroundColor = [UIColor blackColor];
    
    triangle.strokeColor = [UIColor whiteColor];
    triangle.fillColor = [UIColor clearColor];
    [triangle setMiterLimit:0]; 
    
    trianglePoints[0] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/soften andB:self.canvas.width - self.canvas.width/soften], [C4Math randomIntBetweenA:self.canvas.height/soften andB:self.canvas.height - self.canvas.height/soften]);
    trianglePoints[1] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/soften andB:self.canvas.width - self.canvas.width/soften], [C4Math randomIntBetweenA:self.canvas.height/soften andB:self.canvas.height - self.canvas.height/soften]);
    trianglePoints[2] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/soften andB:self.canvas.width - self.canvas.width/soften], [C4Math randomIntBetweenA:self.canvas.height/soften andB:self.canvas.height - self.canvas.height/soften]);
    
    
    triangle = [C4Shape triangle:trianglePoints];
    
    //create 3 shapes for tips of triangle
    CGRect controlFrame = CGRectMake(0, 0, 22, 22);
    CGRect hubFrame = CGRectMake(0, 0, 10, 10);
    controlA = [C4Shape ellipse:controlFrame];
    hub1 = [C4Shape ellipse:hubFrame];
    hub2 = [C4Shape ellipse:hubFrame];
    controlA.fillColor = [UIColor blackColor];
    hub1.fillColor = [UIColor whiteColor];
    hub2.fillColor = [UIColor whiteColor];
    hub1.lineWidth = 0;
    hub2.lineWidth = 0; 
    
    [self makeNewTribounds]; 
    
    NSArray *patternArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:4],
                             [NSNumber numberWithInt:20],
                             nil];
    triangle.lineDashPattern = patternArray;
    
    [triangle addGesture:TAP name:@"tap" action:@"tapped"];
    
       //[triangle set]
    //[triangle setDashPattern:@[10.0f,2.2f] pointCount:2];
    
    [self.canvas addShape:triangle];
    [self.canvas addShape:controlA];
    [self.canvas addShape:hub1];
    [self.canvas addShape:hub2];
    
    //add drag gestures to the control shapes
    [controlA addGesture:PAN name:@"panGesture" action:@"move:"];
    
    //listen for when the control shapes are moved and update the curves as needed
    [self listenFor:@"moved" fromObject:controlA andRunMethod:@"updateControlA"];
    
//    [self listenFor:@"tapped" fromObject:triangle andRunMethod:@"changeTriColor"];
    [self listenFor:@"tapped" fromObject:triangle andRunMethod:@"makeNewTriangle"];
    
    controlA.center = trianglePoints[0] ;
    hub1.center = trianglePoints[1];
    hub2.center = trianglePoints[2]; 
}




-(void)updateControlA {
    
    trianglePoints[0] = controlA.center;
    [triangle triangle:trianglePoints];
    [self makeNewTribounds];
}

-(void)makeNewTribounds {
    CGFloat xOrigin = [C4Math minOfA:trianglePoints[0].x B:trianglePoints[1].x C:trianglePoints[2].x];
    CGFloat yOrigin = [C4Math minOfA:trianglePoints[0].y B:trianglePoints[1].y C:trianglePoints[2].y];
    triangleFrame = CGRectMake(xOrigin, yOrigin, triangle.bounds.size.width, triangle.bounds.size.height);
    [triangle setFrame:triangleFrame];
}

-(void)makeNewTriangle {
    
    [self drawToTheDamnContext]; 
    
    trianglePoints[0] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);
    trianglePoints[1] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);
    trianglePoints[2] = CGPointMake([C4Math randomIntBetweenA:self.canvas.width/8 andB:self.canvas.width - self.canvas.width/8], [C4Math randomIntBetweenA:self.canvas.height/8 andB:self.canvas.height - self.canvas.height/8]);

    
    controlA.center = trianglePoints[0] ;
    hub1.center = trianglePoints[1];
    hub2.center = trianglePoints[2];
    
    [triangle triangle:trianglePoints];
    
    [self makeNewTribounds];
    
}


-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    
    CGPoint p = [[touches anyObject] locationInView:self.canvas];
    controlA.center = p;
    [self updateControlA];

}



-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    
    CGPoint p = [[touches anyObject] locationInView:self.canvas];
    controlA.center = p;
    [self updateControlA];
    
}

-(void) drawToTheDamnContext {
    
    graphicsContext = [self createImageContext];
    [self.canvas renderInContext:graphicsContext];
   
    
    graphicsImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    CGImageCreateWithPNGDataProvider(graphicsContext, , <#bool shouldInterpolate#>, <#CGColorRenderingIntent intent#>)
//    graphicsImageRef = CGImageCreateWithJPEGDataProvider(graphicsContext, <#const CGFloat *decode#>, NO, Fixed);
//    CGImage
    
}


-(CGContextRef)createImageContext {
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    return UIGraphicsGetCurrentContext();
}


@end
