#!/usr/bin/perl

# Copyright (C) 2000 Carsten Haitzler, Geoff Harrison and various contributors
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies of the Software, its documentation and marketing & publicity
# materials, and acknowledgment shall be given in the documentation, materials
# and software packages that this Software was used.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# This is a hack of mandrake's "testroller.pl" that shades/unshades all your
# pager windows

@winlist_temp = `eesh -ewait window_list`;
@intlist_temp = `eesh -ewait \"internal_list internal_ewin\"`;

# here we're going to test to see whether we are shading or unshading
# the window.

if($ARGV[0] eq "1") {
    $shade = "on";
} elsif($ARGV[0] eq "0") {
    $shade = "off";
} else {
    $shade = "";
}


# make sure that we're not an internal window in our list

foreach(@winlist_temp) {
    chomp;
    @stuff = split /\:/;
    $insert = 0;
    foreach $member (@intlist_temp) {
        chomp($member);
        $stuff[0] =~ s/\s+//g;
        $member =~ s/\s+//g;
        if(($member eq $stuff[0]) && ($stuff[1] =~ /^\s*\d+\s*$/)) {
            $insert = 1;
        }
    }
    if($insert) {
        push @winlist,$stuff[0] if($stuff[0]);
    }
}

open IPCPIPE,"| eesh";

# now we're going to walk through each of these windows and
# shade them

foreach $window (@winlist) {
    print IPCPIPE "win_op $window shade $shade\n";
}
close IPCPIPE;
