#!/usr/bin/perl;
use strict;
use Clipboard;
use Clipboard::Win32; # just for successfully compiling to exe in windows

print <<INFO;
===============================================================================
                          Clipboard Text Joiner
         Monitoring system clipboard change and joining multi-line text
               
                    by Wei Shen <shenwei356\@gmail.com>
                               2013-06-28
===============================================================================

INFO

my $head      = ("-" x 31). "[ Clipboard Text ]". ("-" x 30);
my $text      = '';
my $last_text = '';

while (1) {
    $text = Clipboard->paste;
    if ( $text ne $last_text ) {
        $text = &edit_text($text);
        Clipboard->copy($text);
        print "\n$head\n$text\n";
        $last_text = $text;
    }
    sleep 1;
}

sub edit_text {
    my ($text) = @_;
    $text =~ s/-\r?\n\s*/-/gs;
    $text =~ s/([^\-])\r?\n\s*/$1 /gs;
    $text =~ s/\s+/ /gs;
    return $text;
}
