#import "Memory.h"
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <string.h>

bool mem_read(uint64_t addr, void *buf, size_t size) {
    if (!addr || !buf || !size) return false;
    vm_size_t out = 0;
    kern_return_t kr = vm_read_overwrite(mach_task_self(), (vm_address_t)addr, (vm_size_t)size, (vm_address_t)buf, &out);
    return (kr == KERN_SUCCESS && out == size);
}

bool mem_write(uint64_t addr, const void *buf, size_t size) {
    if (!addr || !buf || !size) return false;
    return (vm_write(mach_task_self(), (vm_address_t)addr, (vm_offset_t)buf, (mach_msg_type_number_t)size) == KERN_SUCCESS);
}

uint64_t get_module_base(const char *name) {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *img = _dyld_get_image_name(i);
        if (img && strstr(img, name))
            return (uint64_t)_dyld_get_image_header(i);
    }
    return 0;
}

uint64_t get_il2cpp_base(void) {
    uint64_t base = get_module_base("UnityFramework");
    if (!base) base = get_module_base("StandRise");
    if (!base) base = get_module_base("GameAssembly");
    return base;
}
