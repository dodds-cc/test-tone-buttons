//
//  CustomButton.m
//  SuperpoweredMacOSBoilerplate
//
//  Created by elilien on 11/4/21.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.mouseDownBlock) {
        self.mouseDownBlock();
    }
    while ((theEvent = [[self window] nextEventMatchingMask: NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDragged])) {
        if ([theEvent type] == NSEventTypeLeftMouseUp) {
            if (self.mouseUpBlock) {
                self.mouseUpBlock();
            }
            break;
        }
    }
}

@end
