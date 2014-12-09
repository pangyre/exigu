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

our $VERSION = "0.01";
our $AUTHORITY = 'cpan:ASHLEY';

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
    q|/x/{id:\d+}| => { GET => sub {},
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

Exigu - B<experimental> microblogging platform.

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=head1 Code Repository

L<http://github.com/pangyre/exigu>.

=head1 See Also

...

=head1 Author

Ashley Pond V E<middot> ashley@cpan.org.

=head1 License

You may redistribute and modify this package under the same terms as Perl itself.

=head1 Disclaimer of Warranty

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law. Except when
otherwise stated in writing the copyright holders and other parties
provide the software "as is" without warranty of any kind, either
expressed or implied, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose. The
entire risk as to the quality and performance of the software is with
you. Should the software prove defective, you assume the cost of all
necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify or
redistribute the software as permitted by the above license, be
liable to you for damages, including any general, special, incidental,
or consequential damages arising out of the use or inability to use
the software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of
such damages.

=cut

