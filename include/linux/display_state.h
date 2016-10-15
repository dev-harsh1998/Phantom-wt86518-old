/*
 * include/linux/display_state.h
 *
 * Copyright (c) 2016-2069 Harshit Jain
 * harshitjain6751@gmail.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * This File serves the global Boolean status is_display_on which was intentinally
 * Introduced by me to get the status of display panel. (On or Off State)
 * Willbe using it in places of powersuspend variables for few dependent 
 * Governors,Schedulars to get them compiling :)
 */
 
#ifndef _LINUX_DISPLAY_STATE_H
#define _LINUX_DISPLAY_STATE_H

bool is_display_on(void);

#endif
