//the useed types in the contract

type music_supply = { current_stock : nat ; not_sale : bool ; music_address : address ; music_price : tez ; music_title : string }
type music_storage = (nat, music_supply) map
type return = operation list * music_storage
type music_id = nat

//types that are required for music transfer function 
type transfer_destination =
[@layout:comb]
{
  to_ : address;
  music_id : music_id;
  amount : nat;
}
 
type transfer =
[@layout:comb]
{
  from_ : address;
  txs : transfer_destination list;
}

//address to recieve money from music sales
let manager_address : address = ("tz1RLUinKQTdBnMnkATsHi3SaZYChaEYxYUE" : address)

// main function
let main (music_kind_index, music_storage : nat * music_storage) : return =
  //checks if the music exist
  let music_kind : music_supply =
    match Map.find_opt (music_kind_index) music_storage with
    | Some k -> k
    | None -> (failwith "The NFT music you want isn't here :(" : music_supply)
  in

  // Check if the music is on sale  
  let () = if music_kind.not_sale = true then
    failwith "Sorry, This music is not on sale!"
  in

  //give the price
  let current_purchase_price : tez = music_kind.music_price
  in
  
 //checks if the music is in stock or not
  let () = if music_kind.current_stock = 0n then
    failwith "Better luck next time, the music is out of stock!"
  in

 //update the storage
  let music_storage = Map.update
    music_kind_index
    (Some { music_kind with current_stock = abs (music_kind.current_stock - 1n) })
    music_storage
  in

  let tr : transfer = {
    from_ = Tezos.self_address;
    txs = [ {
      to_ = Tezos.sender;
      music_id = abs (music_kind.current_stock - 1n);
      amount = 1n;
    } ];
  } 
  in

//transaction operation for FA2 transfer
  let entrypoint : transfer list contract = 
    match ( Tezos.get_entrypoint_opt "%transfer" music_kind.music_address : transfer list contract option ) with
    | None -> ( failwith "Invalid external token contract" : transfer list contract )
    | Some e -> e
  in
 
  let fa2_operation : operation =
    Tezos.transaction [tr] 0mutez entrypoint
  in

 //payout 
  let receiver : unit contract =
    match (Tezos.get_contract_opt manager_address : unit contract option) with
    | Some (contract) -> contract
    | None -> (failwith ("Not a contract") : (unit contract))
  in
 
  let payout_operation : operation = 
    Tezos.transaction unit amount receiver 
  in

//returning the list of operations
 ([fa2_operation ; payout_operation], music_storage)
