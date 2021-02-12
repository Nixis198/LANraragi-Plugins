package LANraragi::Plugin::Metadata::nHentaiLookupUsingHdoujin;

use strict;
use warnings;

# Plugins can freely use all Perl packages already installed on the system 
# Try however to restrain yourself to the ones already installed for LRR (see tools/cpanfile) to avoid extra installations by the end-user.
#use Mojo::UserAgent;
use Mojo::JSON qw(from_json);
use Mojo::JSON qw(decode_json);
use Mojo::UserAgent;
use Mojo::DOM;
use URI::Escape;

# You can also use LRR packages when fitting.
# All packages are fair game, but only functions explicitly exported by the Utils packages are supported between versions.
# Everything else is considered internal API and can be broken/renamed between versions.
use LANraragi::Model::Plugins;
use LANraragi::Utils::Logging qw(get_logger);
use LANraragi::Utils::Archive qw(is_file_in_archive extract_file_from_archive);

#Meta-information about your plugin.
sub plugin_info {

    return (
        #Standard metadata
        name         => "nHentai lookup using Hdoujin",
        type         => "metadata",
        namespace    => "nhIDlookup",
        author       => "Nixis198",
        version      => "0.1",
        description  => "Uses the URL/ID from the info.txt file to find the tags better than just searching by name.",
        icon         => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH5QEEFBkR0sAcMAAAAwpJREFUOMtd1H1oVXUYB/DPOffOuTnn1qZUZArlSqbRitatrP7onyIoooigKAst1CKMagRSFBQR1R/ZCzJhEayI3plFxYoKgkEbNNrKfKWXzRVubVen07z39Md9Bjd//xzuPd/nPM/zffklxfYCXIpt8TyFT/A0phtHB1SfwNdiA+5HK/7Es+jLow2vYQZPYSE2YSpAZf8/Ce7DY3gPwyjgOUzko0uCezARRbPoQk90rz4tMd12mZck4AN8jE15XIVvqz4GQ6jHymJ74fQPnovF+EJC4+iAYnvheNTcnMaKc1ReBmfHg8tGLKlatQl18fvUafwWUZtiDOcjrSJ9UYCa8TByyONB1AR2RWDnz1k4luIrdOK8KsAVweNBXIAVOBPLMInfcBOSqgE68H0eH+KuUPR5nIGH8A5GArwDJRyOjd7CC/gZ3+C2aPZIPrp14WX04QQ+xxuNhcPFIwOtB7LKdCeD62m8j4vCu11huW0Ymh9ZQyk5J6FNlkz6tXVk440HSz3L5pbu3N/QtH6ibmq2ppyUqbnlwuKh6VxmcLh5wdF8eW19OWlKT6a7V3dOjo0vKFdctOTuNjMLS0uVkltRSsvJPwm/45lS4ktp9rbufRPFNQXNnZM1WFXKZ/uz7rYTyYY9VysnV+Yyu5FLcveumldoOzJcHOu9iFexL1bdgkGsQW+Yuw0bg4br0J2GJbbiGNaH4/vDJvVhk9XYHNjWsFN7NHkST4SAvbm0o+WSAD8eCiZYHtYp4++YYB2+DhcUwvCj2BmbNaOc4naMY2Uo/TrujIjtiML5lGwOehqwFr/Ef71htdo8LgsD36FywyyKgv4oODuy+wOuiQmXx7v2iGIWWf5oPstHQpT64KgmJnwgCupjtT5cr3IfLsYufBfifIaj+QA+GpzNhcKvhML/4k1ciz1RtC5iVhdDjEXdEOTSjpZhfBrunwng1ojZbDToCwqm8AduCAq24N2gor/Us3c8l3a0ZKHidJB/CIOlnr3SjhaR1xGV6wwOxPNydOOv4P2n7Mep6f8Ar4T65la7tSMAAAAhdEVYdENyZWF0aW9uIFRpbWUAMjAxOToxMToxOSAyMDo0MzowMUTrjeMAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDEtMDRUMjA6MjU6MTcrMDA6MDBOQUbVAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTAxLTA0VDIwOjI1OjE3KzAwOjAwPxz+aQAAAABJRU5ErkJggg==",
        #If your plugin uses/needs custom arguments, input their name here. 
        #This name will be displayed in plugin configuration next to an input box for global arguments, and in archive edition for one-shot arguments.

        #might add this later
        #parameters  => [ { type => "bool", desc => "Save archive title" } ]
    );

}

#TBH i just copied a lot of this code.

#Mandatory function to be implemented by your plugin
sub get_tags {
    
    shift;
    my $lrr_info = shift;    # Global info hash
    my $file   = $lrr_info->{file_path};
    my $url = read_file( $file );
    my $id = get_id( $url );
    my ( $nhtags, $nhtitle ) = get_tags_from_NH( $id );
    return ( tags => $nhtags, title => $nhtitle );
}

sub read_file {
    my $dafile = $_[0];

    if ( is_file_in_archive( $dafile, "info.txt" ) ) {

        # Extract info.txt
        my $filepath = extract_file_from_archive( $dafile, "info.txt" );

        # Open it
        open( my $fh, '<:encoding(UTF-8)', $filepath )
          or return ( error => "Could not open $filepath!" );

        while ( my $line = <$fh> ) {

            # Check if the line starts with URL:
            if ( $line =~ m/URL: (.*)/ ) {
                return ( tags => $1 );
            }
        }
        return ( error => "No URL was found in info.txt!" );

    } else {
        return ( error => "No Hdoujin info.txt file found in this archive!" );
    }
}

sub get_id {
    my $logger = get_logger( "nHentai lookup using Hdoujin", "plugins" );
    my $url = $_[0];
    my $id = '';
    if ( $url =~ /.*\/g\/([0-9]*)\/.*/ ) {
        $logger->debug("Running regex");
        $id = $1;
    } else {
        return ( error => "Could not parse URL.");
    }
    return ( tags => $id );
}

sub test {
    return( 'yeet' )
}

sub get_tags_from_NH {

    my $gID      = $_[0];
    my $returned = "";

    my $logger = get_logger( "nHentai lookup using Hdoujin", "plugins" );

    my $URLgood = "https://nhentai.net/g/$gID/";
    my $ua  = Mojo::UserAgent->new;

    my $textrep = $ua->get($URLgood)->result->body;

    #Find the metadata JSON in the HTML and turn it into an object
    #It's located under a N.gallery JS object.
    my $jsonstring = "{}";
    if ( $textrep =~ /window\._gallery.*=.*JSON\.parse\((.*)\);/gmi ) {
        $jsonstring = $1;
    }

    $logger->debug("Tentative JSON: $jsonstring");

    # nH now provides their JSON with \uXXXX escaped characters.
    # The first pass of decode_json decodes those characters, but still outputs a string.
    # The second pass turns said string into an object properly so we can exploit it as a hash.
    my $json = decode_json $jsonstring;
    $json = decode_json $json;

    my $tags = $json->{"tags"};

    foreach my $tag (@$tags) {

        $returned .= ", " unless $returned eq "";

        #Try using the "type" attribute to craft a namespace.
        #The basic "tag" type the NH API adds by default will be ignored here.
        my $namespace = "";

        unless ( $tag->{"type"} eq "tag" ) {
            $namespace = $tag->{"type"} . ":";
        }

        $returned .= $namespace . $tag->{"name"};

    }

    $logger->info("Sending the following tags to LRR: $returned");

    # Use NH's "pretty" names (romaji titles without extraneous data we already have like (Event)[Artist], etc)
    return ( $returned, $json->{"title"}->{"pretty"} );

}

1;