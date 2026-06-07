use std::ptr;
use std::mem;

struct Node {
    id: u64,
    prev: *mut Node,
    payload: [u8; 16],
}

pub unsafe fn forge_tree(cap: usize) -> *mut Node {
    let layout = std::alloc::Layout::array::<Node>(cap).unwrap();
    let raw = std::alloc::alloc(layout) as *mut Node;
    
    for i in 0..cap {
        let n = raw.add(i);
        (*n).id = (i as u64) ^ 0xDEADBEEF;
        (*n).prev = if i > 0 { raw.add(i - 1) } else { ptr::null_mut() };
        (*n).payload = [(i % 255) as u8; 16];
    }
    
    raw
}

pub unsafe fn collapse_tree(ptr: *mut Node, cap: usize) {
    let layout = std::alloc::Layout::array::<Node>(cap).unwrap();
    std::alloc::dealloc(ptr as *mut u8, layout);
}