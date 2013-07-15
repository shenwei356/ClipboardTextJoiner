#!/usr/bin/env perl
use strict;
use Win32::Clipboard;

print <<INFO;
===============================================================================

                          Clipboard Text Joiner
         Monitoring system clipboard change and joining multi-line text

 Usage  : Just copy and paste as usual
 Author : Wei Shen <shenwei356\@gmail.com>
 Home   : https://github.com/shenwei356/ClipboardTextJoiner
 Chinese: http://blog.shenwei.me/clipboardtextjoiner/
 Version: 2013-06-28

===============================================================================

INFO

my $head = ("-" x 31). "[ Clipboard Text ]". ("-" x 30);
my $clip               = Win32::Clipboard();
my $text               = '';
my $handle_this_change = 1;

while (1) {
    if (
        $clip->WaitForChange()     # clipboard changed
        and $handle_this_change    # handle this change
      )
    {
        next unless $clip->IsText();    # only text will be edited
        $text = $clip->GetText();       # get text from clipboard
        &edit_text(\$text);             # edit text
        $handle_this_change = 0;        # to ignore this change
        $clip->Set($text);              # write back to clipboard
    }
    else {
        $text = $clip->GetText();       # show edited text
        print "\n$head\n$text\n";
        $handle_this_change = 1;        # handle next change
    }
}

sub edit_text {
    my ($text) = @_;
    $$text =~ s/-\r?\n\s*/-/g;          # for rows end with "-"
    $$text =~ s/([^\-])\r?\n\s*/$1 /g;  # for other rows
    $$text =~ s/\s+/ /g;                # joining multi-blanks into one blank
}
