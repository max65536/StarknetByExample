mod tests {
    use store_using_packing::contract::{
        TimeContract, TimeContract::Time, ITimeDispatcher, ITimeDispatcherTrait
    };

    use starknet::deploy_syscall;
    use starknet::class_hash::Felt252TryIntoClassHash;

    use debug::PrintTrait;

    #[test]
    #[available_gas(20000000)]
    fn test_packing() {
        // Set up.
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            TimeContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let mut contract = ITimeDispatcher { contract_address: address0 };

        // Store a Time struct.
        let time = Time { hour: 1, minute: 2 };
        contract.set(time);

        // Read the stored struct.
        let read_time: Time = contract.get();
        assert(read_time.hour == time.hour, 'Time.hour mismatch');
        assert(read_time.minute == time.minute, 'Time.minute mismatch');
    }
}
