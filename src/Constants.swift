/*
 
 Licensed under the MIT license:
 
 Copyright (c) 2019 Michal Duda
 
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

import Foundation

let keyboardVID: Int = 0x2516

enum KeyboardPIDs: Int, CaseIterable {
    case CK550 = 0x007f; // Works - @vookimedlo - this is the only keyboard I have, any contribution for other models is welcome!!!
    case CK530 = 0x009f; // Works - @cscheib - suggested & reported - Thanks!!!
    case CK550v2 = 0x0145; // Works - @adrewb - CK550v2 Version 1.10 model #: GK-550-GKTM1-US
}
