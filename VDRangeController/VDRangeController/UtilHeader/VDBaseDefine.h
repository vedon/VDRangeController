//
//  VDBaseDefine.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#ifndef VDBaseDefine_h
#define VDBaseDefine_h

#if DEBUG
#define VDEnableLog 1
#endif

#ifdef VDEnableLog
#define VDLog NSLog
#else
#define VDLog(...)
#endif


// The C++ compiler mangles C function names. extern "C" { /* your C functions */ } prevents this.
// You should wrap all C function prototypes declared in headers with ASDISPLAYNODE_EXTERN_C_BEGIN/END, even if
// they are included only from .m (Objective-C) files. It's common for .m files to start using C++
// features and become .mm (Objective-C++) files.see (http://www.xs-labs.com/en/blog/2012/01/16/mixing-cpp-objective-c/)
#ifdef __cplusplus
# define EXTERN_C_BEGIN extern "C" {
# define EXTERN_C_END   }
#else
# define EXTERN_C_BEGIN
# define EXTERN_C_END
#endif


#endif /* VDBaseDefine_h */
