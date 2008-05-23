/******************************************************************************
 * $Id$
 * 
 * Copyright (c) 2008 Transmission authors and contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *****************************************************************************/

#import "TrackerTableView.h"

@implementation TrackerTableView

- (void) setTrackers: (NSArray *) trackers
{
    fTrackers = trackers;
}

//alternating rows - first row after group row is white
- (void) highlightSelectionInClipRect: (NSRect) clipRect
{
    NSColor * altColor = [[NSColor controlAlternatingRowBackgroundColors] objectAtIndex: 1];
    
    NSRect visibleRect = clipRect;
    NSRange rows = [self rowsInRect: visibleRect];
    BOOL start = YES;
    
    if (rows.length > 0)
    {
        int i;
        
        //determine what the first row color should be
        if (![[fTrackers objectAtIndex: rows.location] isKindOfClass: [NSNumber class]])
        {
            for (i = rows.location-1; i>=0; i--)
            {
                if ([[fTrackers objectAtIndex: i] isKindOfClass: [NSNumber class]])
                    break;
                start = !start;
            }
        }
        else
        {
            rows.location++;
            rows.length--;
        }
        
        for (i = rows.location; i < NSMaxRange(rows); i++)
        {
            if ([[fTrackers objectAtIndex: i] isKindOfClass: [NSNumber class]])
            {
                start = YES;
                continue;
            }
            
            if (!start)
            {
                [altColor set];
                NSRectFill([self rectOfRow: i]);
            }
            
            start = !start;
        }
        
        float newY = NSMaxY([self rectOfRow: i-1]);
        visibleRect.size.height -= newY - visibleRect.origin.y;
        visibleRect.origin.y = newY;
    }
    
    //remaining visible rows continue alternating
    NSRect rowRect = visibleRect;
    rowRect.size.height = [self rowHeight] + [self intercellSpacing].height;
    
    while (rowRect.origin.y < NSMaxY(visibleRect))
    {
        if (!start)
        {
            [altColor set];
            NSRectFill(rowRect);
        }
        
        start = !start;
        rowRect.origin.y += rowRect.size.height;
    }
    
    [super highlightSelectionInClipRect: clipRect];
}

@end
