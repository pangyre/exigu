#!/usr/bin/env perl
# Can be run this way -> uwsgi --http :3031 -M -p 4 --psgi app.psgi -m
# Strangely, seems to be ever so slighly slower than straightup plackup...
# carton exec "plackup -r"
use 5.16.2;
use utf8;
use strictures;
use Plack::Request;
use Plack::Response;
use Plack::Builder;
use HTTP::Status ":constants", "status_message";
use Encode qw( encode decode );
use Path::Tiny;
use Data::Dump "dump";
use Router::R3;
use HTML::Entities;

package Exigu v0.0.1 {
    use Moo;
    use Path::Tiny;
    # Types...?
    has [qw/ request response /] =>
        is => "ro",
        required => 1,
        ;

    has "root" =>
        is => "ro",
        init_arg => undef,
        default => sub { path(__FILE__)->parent },
        ;
}

my $Routes = "Router::R3"->new(
    # "Home."
    "/" => { "*" => sub {} },
    # Entries.
    "/x/{id:\d+}" => { GET => sub {},
                       POST => sub {},
                       DELETE => sub {},
                       PUT => sub {} },
    # Static content.
    "/{page:.+}" => { "*" => sub {} },
    );

sub {
    my $env = shift; # PSGI env
    my $mss = "MSS"->new( request => Plack::Request->new($env),
                          response => Plack::Response->new(HTTP_NOT_FOUND) );
    # response => Plack::Response->new( status => +HTTP_NOT_FOUND ) );
    # ROUTING/DISPATCH--------------
    my ( $match, $captures ) = $Routes->match( $env->{PATH_INFO} );
    # Defaults.
    $mss->response->status(HTTP_OK) if $match;
    $mss->response->content_type("text/plain; charset=utf8");                     
    if ( $match )
    {
        if ( my $sub = $match->{ $env->{REQUEST_METHOD} } || $match->{"*"} )
        {
            eval { $sub->($mss,$captures) } || warn $/, $@, $/;
        }
    }

    $mss->response->body([ encode "UTF-8",
                           join "\n",
                           join(" ",
                                status_message( $mss->response->status ),
                                decode "UTF-8", $env->{PATH_INFO}),
                           "match: " . dump($match), dump($captures),
                           dump($env), dump([keys %INC]) ])
        unless $mss->response->body;

    $mss->response->finalize;
};

__DATA__

/tmp/dicom.dcm
/tmp/jpeg.jpg

package MSS::Dispatch 0.01 {
    use Router::R3;


};

    [ 200
      [ "Content-Type" => "text/plain; charset=utf8" ],
      [ encode "UTF-8", join"\n", "OHAI\x{2763}\n", dump($match), dump($captures), dump($env), dump([keys %INC]) ]
    ];

=pod

=encoding utf8

=head1 Name

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=head1 Code Repository

L<http://github.com/pangyre/>.

=head1 See Also

WADO spec: L<http://medical.nema.org/Dicom/2011/11_18pu.pdf>.

=head1 Author

Ashley Pond V E<middot> ashley@cpan.org.

=head1 License

None!

=cut

