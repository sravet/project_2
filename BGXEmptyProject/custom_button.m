//
//  custom_button.m
//  BGXEmptyProject
//
//  Created by Steve Ravet on 10/27/18.
//  Copyright © 2018 Example. All rights reserved.
//

#import "custom_button.h"

@implementation custom_button


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  NSLog(@"Drawing button %ld\n", self.tag);
  CGFloat radii = 9.0;

  // the USA red/white/blue button is a special case
  if (self.tag == 6) { // white
    CGFloat color_width = CGRectGetWidth(rect)/3;
    // red
    CGRect boundsr = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect)/3, CGRectGetHeight(rect));
    UIBezierPath *pathr = [UIBezierPath bezierPathWithRoundedRect:boundsr byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(radii, radii)];
    [[UIColor redColor] setFill];
    [pathr fill];
    
    // white
    CGRect boundsw = CGRectMake(CGRectGetMinX(rect)+color_width, CGRectGetMinY(rect), CGRectGetWidth(rect)/3, CGRectGetHeight(rect));
    UIBezierPath *pathw = [UIBezierPath bezierPathWithRect:boundsw];
    [[UIColor whiteColor] setFill];
    [pathw fill];
    
    // blue
    CGRect boundsb = CGRectMake(CGRectGetMinX(rect) + color_width*2, CGRectGetMinY(rect), CGRectGetWidth(rect)/3, CGRectGetHeight(rect));
    UIBezierPath *pathb = [UIBezierPath bezierPathWithRoundedRect:boundsb byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(radii, radii)];
    [[UIColor blueColor] setFill];
    [pathb fill];
  } else { // other buttons just need to set the color, then they're all drawn the same way.
    UIColor *color;
    switch (self.tag) {
      case 7: { // red
        color = [UIColor colorWithHue:0.0 saturation:1.0 brightness:1.0 alpha:1.0];
        break;
      }
      case 8: { // greeen
        color = [UIColor colorWithHue:120.0/360.0 saturation:1.0 brightness:1.0 alpha:1.0];
        break;
      }
      case 9: { // blue
        color = [UIColor colorWithHue:240.0/360.0 saturation:1.0 brightness:1.0 alpha:1.0];
        break;
      }
      case 10: { // yellow
        color = [UIColor colorWithHue:60.0/360.0 saturation:1.0 brightness:.85 alpha:1.0];
        break;
      }
      case 11: { // pink
        color = [UIColor colorWithHue:354.0/360.0 saturation:.29 brightness:1.0 alpha:1.0];
        break;
      }
      case 12: { // dodgers
        color = [UIColor colorWithHue:210.0/360.0 saturation:.88 brightness:1.0 alpha:1.0];
        break;
      }
      case 13: { // sucky longhorns
        color = [UIColor colorWithHue:27.0/360.0 saturation:1.0 brightness:.75 alpha:1.0];
        break;
      }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radii];
    [color setFill];
    [path fill];
  }
}


@end
