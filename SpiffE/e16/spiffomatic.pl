#!/usr/bin/perl

## Script by Garrett LeSage <garrett@linux.com>
## "probably not the most elegant way to do things, but it works..."
## Released under the GPL v2 see http://gnu.org/ for more.

system("clear");

print << 'EOT';
                       __  ___  ___                      __   __      
          .-----.-----|__.'  _.'  _.-----.--------.---.-|  |_|__.----.
          |__ --|  _  |  |   _|   _|  _  |        |  _  |   _|  |  __|
          |_____|   __|__|__| |__| |_____|__|__|__|___._|____|__|____|
                |__|    b y   G a r r e t t   L e S a g e

		>>>>>>>>>> (hit enter for defaults) <<<<<<<<<<

EOT

print "Focused window:\n";

print "   Enter the rgb, in hex format (ex: #355c64): ";
chop($title_focus = <>);
$title_focus =~ s/#//;
if ($title_focus eq "") { $title_focus = "355c64"; }
$title_focus_format = int(hex(substr($title_focus,0,2))/2.55)."/".
	int(hex(substr($title_focus,2,2))/2.55)."/".
	int(hex(substr($title_focus,4,2))/2.55);

print "   Enter hilight percent (ex: 10): ";
chop($title_focus_bright = <>);
if ($title_focus_bright eq "") { $title_focus_bright = "10"; }

print "   Enter dim percent (ex: 10): ";
chop($title_focus_dim = <>);
if ($title_focus_dim eq "") { $title_focus_dim = "10"; }

print "   Enter blur factor (0 for no blur): ";
chop($title_focus_blur = <>);

if ($title_focus_blur eq "") { 
	$title_focus_blur = "";
} else {
	$title_focus_blur = "-blur ".$title_focus_blur;
}


print "\nUnfocused window:\n";

print "   Enter the rgb, in hex format (ex: #3d3b50): ";
chop($title_unfocus = <>);
$title_unfocus =~ s/#//;
if ($title_unfocus eq "") { $title_unfocus = "3d3b50"; }
$title_unfocus_format = int(hex(substr($title_unfocus,0,2))/2.55)."/".
	int(hex(substr($title_unfocus,2,2))/2.55)."/".
	int(hex(substr($title_unfocus,4,2))/2.55);

print "   Enter hilight percent (ex: 10): ";
chop($title_unfocus_bright = <>);
if ($title_unfocus_bright eq "") { $title_unfocus_bright = "10"; }

print "   Enter dim percent (ex: 10): ";
chop($title_unfocus_dim = <>);
if ($title_unfocus_dim eq "") { $title_unfocus_dim = "10"; }

print "   Enter blur factor (0 for no blur): ";
chop($title_unfocus_blur = <>);
if ($title_unfocus_blur eq "") { 
	$title_unfocus_blur = ""; 
} else {
	$title_unfocus_blur = "-blur ".$title_unfocus_blur;
}

print "\n";

@focus = ("focused","unfocused");
@orientation = ("horizontal","vertical");
@shade = ("normal","hilight","dim");

for $focus  (@focus) {
	if ($focus =~ m/^focused$/) {
		$mog_format	= $title_focus_format;
		$mog_bright	= $title_focus_bright;
		$mog_dim	= $title_focus_dim;
		$mog_blur	= $title_focus_blur;
	} else {
		$mog_format	= $title_unfocus_format;
		$mog_bright	= $title_unfocus_bright;
		$mog_dim	= $title_unfocus_dim;
		$mog_blur	= $title_unfocus_blur;
	}
	for $orientation  (@orientation) {
		for $shade (@shade) {
			if ($shade =~ /^normal$/) { $mog_shade = "-$mog_dim,10"; }
			if ($shade =~ /^dim$/) { $mog_shade = "0,10 -contrast"; }
			if ($shade =~ /^hilight$/) { $mog_shade = "$mog_bright,10"; }
			
			system("cp -f images/bar_template_${orientation}.png images/bar_${focus}_${orientation}_${shade}.png");
			print "Generating $orientation $shade $focus..";
			system("mogrify -colorize $mog_format -modulate $mog_shade $mog_blur images/bar_${focus}_${orientation}_${shade}.png");
			print "done!\n";
		}
	}
}

print "Generating menu selection colors...";
$menu_format = $title_unfocus_format;
@menu_unfocus = ("image_bg","menu2","menu_sel");
for $menu_unfocus (@menu_unfocus) {
	system("cp -f menustyles/images/template_${menu_unfocus}.png menustyles/images/${menu_unfocus}.png");
	system("mogrify -colorize $menu_format -modulate 0,5 menustyles/images/${menu_unfocus}.png");
}
$menu_format = $title_focus_format;
@menu_focus = ("menu3");
for $menu_focus (@menu_focus) {
	system("cp -f menustyles/images/template_${menu_focus}.png menustyles/images/${menu_focus}.png");
	system("mogrify -colorize $menu_format -modulate 0,5 menustyles/images/${menu_focus}.png");
}
print "done!\n";

print "Generating iconbox backgrounds...";
$iconbox_format = $title_unfocus_format;
@titlebox_background = ("vertical","horizontal");
for $titlebox_background (@titlebox_background) {
	system("cp -f iconbox/images/template_${titlebox_background}.png iconbox/images/${titlebox_background}.png");
	system("mogrify -colorize $iconbox_format -modulate 0,0-10 iconbox/images/${titlebox_background}.png");
}
print "done!\n";

print "\nClearing relevant cache...";
system("grep -ri bar_ ../../cached/cfg | cut -f1 -d: | xargs rm -f");
print "done!\n";

print "Adjusting your user_theme.cfg...";
system("sed s/.etheme//g ../../user_theme.cfg > ../../user_theme.cfg");
print "done!\n\n";

print "Would you like to restart E for your changes to take effect? (Y/n) ";
chop($yesno = <>);
if ($yesno =~ m/^n/i) {
	print "\n\n			NOT RESTARTING ENLIGHTENMENT";
} else {
	print "\n\n			Restarting E. Please wait...";
	system("eesh -e restart");
}

print "\n\n";
