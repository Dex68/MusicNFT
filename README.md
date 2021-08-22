# Buy MusicNFT
1. With CameLIGO
2. A smart contract t buy MusicNFT
3. gitattributes configure C# to highlight

## Storage example

    Map.literal [ 
     (0n, { 
       current_stock = 222n ; 
       music_address = ("Address of the MusicNFT" : address); 
       music_price = 12mutez;
       music_title = "Love";
     }); 
     (1n, { 
       current_stock = 333n; 
       music_address = ("Address of the MusicNFT" : address); 
       music_price = 21mutez;
       music_price = "Great"
     });
     ...
    ]
