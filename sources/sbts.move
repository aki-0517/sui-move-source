module nfts::sbts {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{Self, TxContext};

    // Define a SoulBoundToken struct with fields like id, name, description, and url.  
    // This struct should have the key and store abilities but not copy or drop to prevent transfer and duplication.
    struct SoulBoundToken has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
    }

    public entry fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sbt = SoulBoundToken {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };
        let sender = tx_context::sender(ctx);
        transfer::public_transfer(sbt, sender);
    }

    public fun name(sbt: &SoulBoundToken): &string::String {
        &sbt.name
    }

    public fun description(sbt: &SoulBoundToken): &string::String {
        &sbt.description
    }

    public fun url(sbt: &SoulBoundToken): &Url {
        &sbt.url
    }

    // Optional: Function to burn the SBT
    public entry fun burn(sbt: SoulBoundToken) {
        let SoulBoundToken { id, name: _, description: _, url: _ } = sbt;
        object::delete(id)
    }
}
