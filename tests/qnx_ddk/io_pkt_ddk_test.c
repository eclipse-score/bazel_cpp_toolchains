/********************************************************************************
 * Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 ********************************************************************************/
/*
 * *******************************************************************************
 * Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 * *******************************************************************************
 */

/*
 * Compile-only smoke test for QNX SDP's io-pkt Driver Development Kit (DDK).
 *
 * io-pkt's network stack is a fork of FreeBSD's kernel, so building anything
 * against usr/include/devs requires a "kernel" personality: __FreeBSD__,
 * _KERNEL, HAVE_KERNEL_OPTION_HEADERS (see usr/include/devs/devs.mk). These
 * flags are not on by default; this target opts in via the toolchain's
 * `io_pkt_ddk` feature (see features/custom/qnx/io_pkt_ddk and this
 * package's BUILD file). Without that feature enabled, this file fails to
 * compile, since the DDK defines and usr/include/devs search paths are absent.
 */

#ifndef __FreeBSD__
#error "io-pkt DDK build must define __FreeBSD__ (see devs/devs.mk)"
#endif
#ifndef _KERNEL
#error "io-pkt DDK build must define _KERNEL (see devs/devs.mk)"
#endif

#include <sys/param.h>
#include <sys/queue.h>


/* Only devs/sys/param.h defines this; the plain QNX sys/param.h does not.
 * Guards against the search path silently falling back to the non-DDK header. */
#ifndef __FreeBSD_kernel__
#error "expected devs/sys/param.h (FreeBSD kernel headers) to shadow the QNX sys/param.h"
#endif

struct ddk_test_entry {
    int id;
    TAILQ_ENTRY(ddk_test_entry) link;
};

TAILQ_HEAD(ddk_test_queue, ddk_test_entry);

size_t ddk_test_queue_count(struct ddk_test_queue *head) {
    struct ddk_test_entry *entry;
    size_t count = 0;

    TAILQ_FOREACH(entry, head, link) {
        count++;
    }
    return count;
}
