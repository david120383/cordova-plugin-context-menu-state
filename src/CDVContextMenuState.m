/*
The MIT License (MIT)

Copyright (c) 2017 Mtech Access Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */
#import "CDVContextMenuState.h"


@implementation CDVContextMenuState

- (void)pluginInitialize
{
        // hide context menu by default
        _contextMenuVisible = NO;

        // add observer for menu controller
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillBeShown:) name:UIMenuControllerWillShowMenuNotification object:nil];
}

- (void)setVisible:(CDVInvokedUrlCommand*)command
{
        // get new menu state
        id value = [command argumentAtIndex:0];
        if (!([value isKindOfClass:[NSNumber class]])) {
                value = [NSNumber numberWithBool:YES];
        }

        _contextMenuVisible = [value boolValue];

        // remap observers as necessary
        if (_contextMenuVisible) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
        }else{
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillBeShown:) name:UIMenuControllerWillShowMenuNotification object:nil];
        }
}

- (void)menuWillBeShown:(NSNotification *)notification {
        dispatch_async(dispatch_get_main_queue(),^{
                [[UIMenuController sharedMenuController] setMenuVisible:_contextMenuVisible animated:_contextMenuVisible];
        });
}

@end
