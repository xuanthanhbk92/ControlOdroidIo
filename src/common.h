#ifndef __COMMON_H__
#define __COMMON_H__ 1

#include "zlog.h"

extern zlog_category_t *g_zc;

#define INF(__fmt,__args...) zlog_info(g_zc, __fmt, ##__args);
#define ERR(__fmt,__args...) zlog_error(g_zc, __fmt, ##__args);
#define DBG(__fmt,__args...) zlog_debug(g_zc, __fmt, ##__args);
#define WARN(__fmt,__args...) zlog_warn(g_zc, __fmt, ##__args);

#endif /* __COMMON_H__  */
