#include <stddef.h>
#include <stdint.h>

#include "console.h"
#include "fdt.h"

#define STACK_SIZE     0x8000

void kinit(uint64_t hartid, void* fdt) {
    console_printf("[kinit] toki, ale o!\n[kinit] hartid: %lx\n[kinit] fdt pointer: %p\n", hartid, fdt);

    fdt_t devicetree = verify_fdt(fdt);
    if (devicetree.header == NULL) {
        console_printf("[kinit] invalid fdt pointer %p\n", fdt);
        while(1);
    }

    dump_fdt(&devicetree, NULL);

    while (1);
}
