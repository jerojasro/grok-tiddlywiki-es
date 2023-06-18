# Locale::Po4a::Ini -- Convert ini files to PO file, for translation.
#
# This program is free software; you may redistribute it and/or modify it
# under the terms of GPL (see COPYING).
#

############################################################################
# Modules and declarations
############################################################################

require Exporter;

package Locale::Po4a::Tiddlywiki;

use 5.006;
use strict;
use warnings;

use Locale::Po4a::TransTractor qw(process new);
use Locale::Po4a::Common qw(wrap_mod);
use JSON qw(encode_json decode_json);

use vars qw(@ISA @EXPORT $AUTOLOAD);
@ISA    = qw(Locale::Po4a::TransTractor);
@EXPORT = qw();

my $debug = 0;

sub initialize {
}

sub parse {
    my $self = shift;
    my ( $line, $ref );
    my $par;

    ( $line, $ref ) = $self->shiftline();

    print STDERR wrap_mod( "tiddlywiki", "BEGIN" ) if $self->debug();
    while ( defined($line) ) {
        if ( $line =~ /^  "human_title": "/ ) {

            $line =~ m/^  "human_title": "(.*)"(,?)$/;
            my $quoted_text = $1;
            my $post_text = $2;

            $par = $self->translate( $quoted_text, $ref, "human_title" );
            $self->pushline('  "human_title": ' . '"' . $par . '"' . $post_text . "\n" );

        } elsif ( $line =~ /^  "answer": "/ ) {
            $line =~ m/^  "answer": "(.*)"(,?)$/;
            my $quoted_text = $1;
            my $post_text = $2;

            $par = $self->translate( $quoted_text, $ref, "answer" );
            $self->pushline('  "answer": ' . '"' . $par . '"' . $post_text . "\n" );

        } elsif ( $line =~ /^  "question": "/ ) {
            $line =~ m/^  "question": "(.*)"(,?)$/;
            my $quoted_text = $1;
            my $post_text = $2;

            $par = $self->translate( $quoted_text, $ref, "question" );
            $self->pushline('  "question": ' . '"' . $par . '"' . $post_text . "\n" );

        } elsif ( $line =~ /^  "text": "/ ) {
            $line =~ m/^  "text": "(.*)"(,?)$/;
            my $quoted_text = $1;
            my $post_text = $2;

            my @unt_pars = split(/\\n\\n/, $quoted_text);
            my @pars = ();

            foreach my $unt_par (@unt_pars) {
                $par = $self->translate( $unt_par, $ref, "text" );
                push(@pars, $par);
            }

            $self->pushline('  "text": ' . '"' . join("\\n\\n", @pars) . '"' . $post_text . "\n" );
        } else {
            print STDERR wrap_mod( "tiddlywiki", "line" . $line ) if $self->debug();
            $self->pushline("$line");
        }

        # Reinit the loop
        ( $line, $ref ) = $self->shiftline();
    }
}

##############################################################################
# Module return value and documentation
##############################################################################

1;
__END__

=encoding UTF-8

=head1 NAME

Locale::Po4a::Ini - convert INI files from/to PO files

=head1 DESCRIPTION

Locale::Po4a::Ini is a module to help the translation of INI files into other
[human] languages.

The module searches for lines of the following format and extracts the quoted
text:

identificator="text than can be translated"

NOTE: If the text is not quoted, it will be ignored.

=head1 SEE ALSO

L<Locale::Po4a::TransTractor(3pm)>, L<po4a(7)|po4a.7>

=head1 AUTHORS

 Razvan Rusu <rrusu@bitdefender.com>
 Costin Stroie <cstroie@bitdefender.com>

=head1 COPYRIGHT AND LICENSE

Copyright © 2006 BitDefender

This program is free software; you may redistribute it and/or modify it
under the terms of GPL (see the COPYING file).

=cut
