// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

// DEPRECATED child count no longer tracked
// tests valid deletion of an object that has children
// Both child and parent are deleted in one transaction

//# init --addresses test=0x0 --accounts A B

//# publish

module test::m {
    use sui::tx_context::{Self, TxContext};

    struct S has key, store {
        id: sui::object::UID,
    }

    public entry fun mint(ctx: &mut TxContext) {
        let s = S { id: sui::object::new(ctx) };
        sui::transfer::transfer(s, tx_context::sender(ctx))
    }

    public entry fun transfer(s: S, recipient: address) {
        sui::transfer::transfer(s, recipient)
    }

    public entry fun transfer_to_object(child: S, parent: &mut S) {
        sui::transfer::transfer_to_object(child, parent)
    }

    public entry fun delete_both(s1: S, s2: S) {
        let S { id } = s1;
        sui::object::delete(id);
        let S { id } = s2;
        sui::object::delete(id)
    }

}

//
// Test deleting parent and child in the same txn, parent first
//

//# run test::m::mint --sender A

//# run test::m::mint --sender A

//# run test::m::transfer_to_object --sender A --args object(109) object(107)

//# view-object 107

//# run test::m::delete_both --sender A --args object(107) object(109)

//
// Test deleting parent and child in the same txn, child first
//

//# run test::m::mint --sender A

//# run test::m::mint --sender A

//# run test::m::transfer_to_object --sender A --args object(115) object(113)

//# view-object 113

//# run test::m::delete_both --sender A --args object(115) object(113)
