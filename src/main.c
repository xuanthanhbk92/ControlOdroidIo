#include <stdio.h>

#include "common.h"
#include "command_processor.h"

zlog_category_t *g_zc = NULL;

int main() {
	int res;

	res = zlog_init("/etc/orbitio.conf");
	if (res) {
		printf("init failed %d\n", res);
		return -1;
	}

	g_zc = zlog_get_category("OrbitIO");
	if (!g_zc) {
		printf("get cat fail\n");
		zlog_fini();
		return -2;
	}

	ERR("===============================ORBIT IO START===================================");
	// START OF CODE




	// END OF CODE
	zlog_fini();

	return 0;
}