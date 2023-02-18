use array::ArrayTrait;

//! Stack module
/// Stack representation.
#[derive(Drop, Copy)]
struct Stack {
    inner: Array::<u256>, 
}

/// Stack trait
trait StackTrait {
    /// Create a new stack.
    fn new() -> Stack;
    /// Push a value onto the stack.
    fn push(ref self: Stack, value: u256);
    /// Pop a value from the stack.
    fn pop(ref self: Stack) -> Option::<u256>;
    /// Peek the Nth item from the stack.
    fn peek(ref self: Stack, idx: u32) -> Option::<u256>;
    /// Return the length of the stack
    fn len(ref self: Stack) -> u32;
    // recursively construct a stack
    fn recursive_build(ref self: Stack, len: u32, count: u32, ref target: Stack);
}

/// Stack implementation for the Stack trait.
impl StackImpl of StackTrait {
    /// Create a new stack
    /// # Returns
    /// A new stack
    fn new() -> Stack {
        let inner = array_new::<u256>();
        return Stack { inner: inner };
    }

    /// Push a value onto the stack.
    /// # Arguments
    /// * `self` - The stack
    /// * `value` - The value to push
    fn push(ref self: Stack, value: u256) {
        // Deconstruct the stack struct so we can mutate the inner
        let Stack{inner: mut inner } = self;
        inner.append(value);
        // Reconstruct the stack struct
        self = Stack { inner };
    }

    /// Pop a value from the stack.
    /// # Arguments
    /// * `self` - The stack
    /// # Returns
    /// The popped value
    fn pop(ref self: Stack) -> Option::<u256> {
        // Deconstruct the stack struct because we consume it
        let Stack{inner: mut inner } = self;
        let len = inner.len();

        // Reconstruct the stack struct
        let value = inner.get(len - 1_u32);

        // Create a new stack
        let mut tmp = StackImpl::new();
        tmp.recursive_build(len - 1_u32, 0_u32, ref self);

        self = Stack { inner };
        self = tmp;
        value
    }

    /// Recursively build from an array
    /// # Arguments
    /// * `self` - The stack
    /// * `len` - The length of the recursive loop
    /// * `array` - The u256 array to iterate over
    fn recursive_build(ref self: Stack, len: u32, count: u32, ref target: Stack) {
        if count == len {
            return ();
        }
        let Stack{inner: mut inner } = target;
        let value = inner.get(count);
        match value {
            Option::Some(val) => {
                self.push(val);
            },
            Option::None(_) => {
                return ();
            }
        }
        target = Stack { inner };
        return self.recursive_build(len, count + 1_u32, ref target);
    }

    /// Peek the Nth item from the stack.
    /// # Arguments
    /// * `self` - The stack
    /// * `idx` - The stack index to peek
    /// # Returns
    /// The peeked value
    fn peek(ref self: Stack, idx: u32) -> Option::<u256> {
        // Deconstruct the stack struct because we consume it
        let Stack{inner: mut inner } = self;
        let stack_len = inner.len();
        // Index must be positive
        if idx < 0_u32 {
            self = Stack { inner };
            return Option::<u256>::None(());
        }
        // Index must be greater than the length of the stack
        if idx >= stack_len {
            self = Stack { inner };
            return Option::<u256>::None(());
        }
        // Reconstruct the stack struct because next line can panic
        self = Stack { inner };
        // Compute the actual index of the underlying array
        let actual_idx = stack_len - idx - 1_u32;

        // Deconstruct the stack struct because we consume it
        let Stack{inner: mut inner } = self;
        let value = inner.get(actual_idx);

        self = Stack { inner };
        value
    }

    /// Return the length of the stack
    /// # Returns
    /// The length of the stack
    fn len(ref self: Stack) -> u32 {
        // Deconstruct the stack struct because we consume it
        let Stack{inner: mut inner } = self;
        let len = inner.len();
        // Reconstruct the stack struct
        self = Stack { inner };
        len
    }
}

impl Array2DU256Drop of Drop::<Array::<u256>>;
impl Array2DU256Copy of Copy::<Array::<u256>>;
