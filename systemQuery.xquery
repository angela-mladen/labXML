let $artists := doc("Artists.xml")//ARTIST
let $albums := doc("Albums.xml")//ALBUM
let $cds := doc("CatalogCD.xml")//CD
let $clients := doc("Clients.xml")//CLIENT
let $rents := doc("Rent.xml")//RENT
let $djs := doc("DJ.xml")//DJ
let $groups := doc("Groups.xml")//GROUP
let $singers := doc("Singers.xml")//SINGER

let $allArtists :=
    for $artist in $artists
    let $artistId := $artist/@ID
    let $artistAlbums :=
        for $album in $albums
        where $album/@ARTIST_ID = $artistId
        let $albumId := $album/@ID
        let $albumCDs :=
            for $cd in $cds
            where $cd/@ALBUM_ID = $albumId
            return $cd
        return <ALBUM ID="{$albumId}">{$album/*}{$albumCDs}</ALBUM>
    return 
        <ARTIST ID="{$artistId}">
            {$artist/*}
            {$artistAlbums}
        </ARTIST>

let $clientRentals :=
    for $client in $clients
    let $clientRentals :=
        for $rent in $rents
        where $rent/@CLIENT_ID = $client/@ID
        return $rent
    return 
        <CLIENT ID="{$client/@ID}">
            {$client/*}
            {$clientRentals}
        </CLIENT>

let $artistDJs :=
    for $dj in $djs
    let $artist :=
        for $artist in $allArtists
        where $artist/@ID = $dj/@ID
        return $artist
    return 
        if (exists($artist))
        then <ARTIST_DJ id="{$dj/@ID}">{$artist/*, $dj}</ARTIST_DJ>
        else ()

let $artistGroups :=
    for $group in $groups
    let $artist :=
        for $artist in $allArtists
        where $artist/@ID = $group/@ID
        return $artist
    return 
        if (exists($artist))
        then <ARTIST_GROUP id="{$group/@ID}">{$artist/*, $group}</ARTIST_GROUP>
        else ()

let $artistSingers :=
    for $singer in $singers
    let $artist :=
        for $artist in $allArtists
        where $artist/@ID = $singer/@ID
        return $artist
    return 
        if (exists($artist))
        then <ARTIST_SINGER id="{$singer/@ID}">{$artist/*, $singer}</ARTIST_SINGER>
        else ()

return 
    <SYSTEM>
        {$clientRentals}
        {$artistDJs}
        {$artistGroups}
        {$artistSingers}
    </SYSTEM>
