#![no_std]
#![no_main]
#![feature(asm_experimental_arch)]

#[panic_handler]
fn rust_panic_handler(_: &::core::panic::PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
extern "C" fn main() {
    unsafe {
        ::core::arch::asm!("
                ldd   {tmp}, X+0
                ldd   {tmp}, X+1
            ",
            tmp = out(reg) _,
            in("X") &0xAABB_u16,
        );
    }
}
