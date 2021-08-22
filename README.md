# Buy MusicNFT
1. With CameLIGO
2. A smart contract t buy MusicNFT
3. Some music cannot be bought, if `not_sale = true`
4. gitattributes configure C# to highlight

## Storage example

    Map.literal [ 
     (0n, { 
       current_stock = 222n ; 
       music_address = ("Address of the MusicNFT" : address); 
       music_price = 12mutez;
       not_sale = false;
       music_title = "Love";
     }); 
     (1n, { 
       current_stock = 333n; 
       music_address = ("Address of the MusicNFT" : address); 
       music_price = 21mutez;
       not_sale = false;
       music_title = "Great"
     });
     ...
    ]
