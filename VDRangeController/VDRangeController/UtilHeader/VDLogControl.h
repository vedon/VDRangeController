//
//  VDLogControl.h
//  VDRangeController
//
//  Created by vedon on 7/9/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#ifndef VDLogControl_h
#define VDLogControl_h

#if DEBUG

//#define kVDReusePoolLog

//#define kVDDisplayItemLog

/**
 *  Use for debug the Visible,Display,MeasureLayout,FetchData blocks status
 *  in orde to checkout the area of the interfaceState is right or not
 */
//#define kVDDisplayItemDetailLog 
#endif


//
#ifdef kVDDisplayItemLog
#define VDDisplayItemLog NSLog
#else
#define VDDisplayItemLog(...)
#endif


//
#ifdef kVDReusePoolLog
#define VDReusePoolLog NSLog
#else
#define VDReusePoolLog(...)
#endif

#endif /* VDLogControl_h */
