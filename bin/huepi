#!/usr/bin/perl -s

#
# HuePl "HYUU-pull"
# A Perl Hue lighting system command line utility
# Just add cURL!
# (C)2016 Cameron Kaiser and Contributors. All rights reserved.
# Distributed under the Floodgap Free Software License

BEGIN {
	$VERSION = "v0.5.1";
        if ($] >= 5.014000 && $ENV{'PERL_SIGNALS'} ne 'unsafe') {
                $signals_use_posix = 1;
        } else {
                $ENV{'PERL_SIGNALS'} = 'unsafe';
        }
}

$lastexception = 0;
@wend = ('-s', '-m', '20', '-A', 'HuePl', '-H', 'Expect:');
@wind = @wend;
@wend = (@wend, '-X', 'POST');
@wund = (@wend, '-X', 'PUT');
eval "use POSIX;";

$exit_mode = 0;
sub iexit {
	my $rc = shift;
	exit($rc) unless ($exit_mode);
}

$stringify_args = sub {
	my $basecom = shift;
	my $resource = shift;
	my $data = shift;
	my $dont_do_auth = shift;
	my $p;
	my $l = '';

	foreach $p (@_) {
		if ($p =~ /^-/) {
			$l .= "\n" if (length($l));
			$l .= "$p ";
			next;
		}
		$l .= $p;
	}
	$l .= "\n";

	# sign our request
	unless ($dont_do_auth) {
#		$l .= "-H \"Authorization: Bearer $bearertoken\"\n";
	}

	# if resource is an arrayref, then it's a GET with URL
	# and args
	$resource = join('?', @{ $resource })
		if (ref($resource) eq 'ARRAY');
	$l .= "url = \"$resource\"\n";
	$data =~ s/"/\\"/g;
	$l .= "data = \"$data\"\n" if length($data);
	return ("$basecom -K -", $l, undef);
};

sub sigify {
        # this routine abstracts setting signals to a subroutine reference.
        # check and see if we have to use POSIX.pm (Perl 5.14+) or we can
        # still use $SIG for proper signalling. We prefer the latter, but
        # must support the former.
        my $subref = shift;
        my $k;

        if ($signals_use_posix) {
                my @w;
                my $sigaction = POSIX::SigAction->new($subref);
                while ($k = shift) {
                        my $e = &posix_signal_of($k);
                        # some signals may not exist on all systems.
                        next if (!(0+$e));
                        POSIX::sigaction($e, $sigaction)
                                || die("sigaction failure: $! $@\n");
                }
        } else {
                while ($k = shift) { $SIG{$k} = $subref; }
        }
}
sub posix_signal_of {
        die("never call posix_signal_of if signals_use_posix is false\n")
                if (!$signals_use_posix);

        # this assumes that POSIX::SIG* returns a scalar int value.
        # not all signals exist on all systems. this ensures zeroes are
        # returned for locally bogus ones.
        return 0+(eval("return POSIX::SIG".shift));
}

sub parsejson {
	my $data = shift;
	my $my_json_ref = undef; # durrr hat go on foot
	my $i;
	my $tdata;
	my $seed;
	my $bbqqmask;
	my $ddqqmask;
	my $ssqqmask;

	# test for single logicals
	return {
		'ok' => 1,
		'result' => (($1 eq 'true') ? 1 : 0),
		'literal' => $1,
			} if ($data =~ /^['"]?(true|false)['"]?$/);

	# first isolate escaped backslashes with a unique sequence.
	$bbqqmask = "BBQQ";
	$seed = 0;
	$seed++ while ($data =~ /$bbqqmask$seed/);
	$bbqqmask .= $seed;
	$data =~ s/\\\\/$bbqqmask/g;

	# next isolate escaped quotes with another unique sequence.
	$ddqqmask = "DDQQ";
	$seed = 0;
	$seed++ while ($data =~ /$ddqqmask$seed/);
	$ddqqmask .= $seed;
	$data =~ s/\\\"/$ddqqmask/g;

	# then turn literal ' into another unique sequence. you'll see
	# why momentarily.
	$ssqqmask = "SSQQ";
	$seed = 0;
	$seed++ while ($data =~ /$ssqqmask$seed/);
	$ssqqmask .= $seed;
	$data =~ s/\'/$ssqqmask/g;

	# here's why: we're going to turn doublequoted strings into single
	# quoted strings to avoid nastiness like variable interpolation.
	$data =~ s/\"/\'/g;

	# and then we're going to turn the inline ones all back except
	# ssqq, which we'll do last so that our syntax checker still works.
	$data =~ s/$bbqqmask/\\\\/g;
	$data =~ s/$ddqqmask/"/g;

	print STDOUT "$data\n" if ($superverbose);

	# first, generate a syntax tree.
	$tdata = $data;
	1 while $tdata =~ s/'[^']*'//; # empty strings are valid too ...
	$tdata =~ s/-?[0-9]+\.?[0-9]*([eE][+-][0-9]+)?//g;
		# have to handle floats *and* their exponents
	$tdata =~ s/(true|false|null)//g;
	$tdata =~ s/\s//g;

	print STDOUT "$tdata\n" if ($superverbose);

	# now verify the syntax tree.
	# the remaining stuff should just be enclosed in [ ], and only {}:,
	# for example, imagine if a bare semicolon were in this ...
	if ($tdata !~ s/^\[// || $tdata !~ s/\]$// || $tdata =~ /[^{}:,]/) {
		$tdata =~ s/'[^']*$//; # cut trailing strings
		if (($tdata =~ /^\[/ && $tdata !~ /\]$/)
				|| ($tdata =~ /^\{/ && $tdata !~ /\}$/)) {
			# incomplete transmission
			&exception(10, "*** JSON warning: connection cut\n");
			return undef;
		}
		if ($tdata =~ /(^|[^:])\[\]($|[^},])/) { # oddity
			&exception(11, "*** JSON warning: null list\n");
			return undef;
		}
		# at this point all we should have are structural elements.
		# if something other than JSON structure is visible, then
		# the syntax tree is mangled. don't try to run it, it
		# might be unsafe.
		if ($tdata =~ /[^\[\]\{\}:,]/) {
			&exception(99, "*** JSON syntax error\n");
			print STDOUT <<"EOF" if ($verbose);
--- data received ---
$data
--- syntax tree ---
$tdata
--- JSON PARSING ABORTED DUE TO SYNTAX TREE FAILURE --
EOF
			return undef;
		}
	}

	# syntax tree passed, so let's turn it into a Perl reference.
	# have to turn colons into ,s or Perl will gripe. but INTELLIGENTLY!
	1 while
	($data =~ s/([^'])'\s*:\s*(true|false|null|\'|\{|\[|-?[0-9])/\1\',\2/);

	# removing whitespace to improve interpretation speed actually made
	# it SLOWER.
	#($data =~ s/'\s*,\s*/',/sg);
	#($data =~ s/\n\s*//sg);

	# finally, single quotes, just before interpretation.
	$data =~ s/$ssqqmask/\\'/g;

	# now somewhat validated, so safe (?) to eval() into a Perl struct
	eval "\$my_json_ref = $data;";
	print STDOUT "$data => $my_json_ref $@\n"  if ($superverbose);

	# do a sanity check
	if (!defined($my_json_ref)) {
		&exception(99, "*** JSON syntax error\n");
		print STDOUT <<"EOF" if ($verbose);
--- data received ---
$data
--- syntax tree ---
$tdata
--- JSON PARSING FAILED --
$@
--- JSON PARSING FAILED --
EOF
	}

	return $my_json_ref;
}

sub backticks {
	# more efficient/flexible backticks system
	my $comm = shift;
	my $rerr = shift;
	my $rout = shift;
	my $resource = shift;
	my $data = shift;
	my $dont_do_auth = shift;
	my $buf = '';
	my $undersave = $_;
	my $pid;
	my $args;

	($comm, $args, $data) = &$stringify_args($comm, $resource,
		$data, $dont_do_auth, @_);
	print STDOUT "$comm\n$args\n$data\n" if ($superverbose);
	if(open(BACTIX, '-|')) {
		while(<BACTIX>) {
			$buf .= $_;
		} close(BACTIX);
		$_ = $undersave;
		return $buf; # and $? is still in $?
	} else {
		$in_backticks = 1;
		&sigify(sub {
			die(
		"** user agent not honouring timeout (caught by sigalarm)\n");
		}, qw(ALRM));
		alarm 120; # this should be sufficient
		if (length($rerr)) {
			close(STDERR); 
			open(STDERR, ">$rerr");
		}
		if (length($rout)) {
			close(STDOUT);
			open(STDOUT, ">$rout");
		}
		if(open(FRONTIX, "|$comm")) {
			print FRONTIX "$args\n";
			print FRONTIX "$data" if (length($data));
			close(FRONTIX);
		} else {
			die(
			"backticks() failure for $comm $rerr $rout @_: $!\n");
		}
		$rv = $? >> 8;
		exit $rv;
	}
}

sub wherecheck {
	my ($prompt, $filename, $fatal) = (@_);
	my (@paths) = split(/\:/, $ENV{'PATH'});
	my $setv = '';

	push(@paths, '/usr/bin'); # the usual place
	@paths = ('') if ($filename =~ m#^/#); # for absolute paths

	print STDOUT "$prompt ... " unless ($silent);
	foreach(@paths) {
		if (-r "$_/$filename") {
			$setv = "$_/$filename";
			1 while $setv =~ s#//#/#;
			print STDOUT "$setv\n" unless ($silent);
			last;
		}
	}
	if (!length($setv)) {
		print STDOUT "not found.\n";
		if ($fatal) {
			print STDOUT $fatal;
			exit(1);
		}
	}
	return $setv;
}

sub url_oauth_sub {
        my $x = shift;
        $x =~ s/([^-0-9a-zA-Z._~])/"%".uc(unpack("H*",$1))/eg; return $x;
}

# this is a sucky nonce generator. I was looking for an awesome nonce
# generator, and then I realized it would only be used once, so who cares?
# *rimshot*
sub generate_nonce { unpack("H32", pack("u", rand($$).$$.time())); }

sub exception {
	my ($num, $tex) = (@_);
	$lastexception = $num;
	print STDOUT "$tex" if ($verbose);
}

sub grabjson {
	my $url = shift;
	my $no_auth = shift;
	my $data;
	chomp($data = &backticks($curl,
			'/dev/null', undef, $url, undef,
			$no_auth, @wind));
	return &genericnetworkjson($data, $url, $no_auth);
}
sub postjson {
	my $url = shift;
	my $postdata = shift;
	my $no_auth = shift;
	my $data;
	chomp($data = &backticks($curl,
			'/dev/null', undef, $url, $postdata,
			$no_auth, @wend));
	return &genericnetworkjson($data, $url, $no_auth);
}
sub putjson {
	my $url = shift;
	my $postdata = shift;
	my $no_auth = shift;
	my $data;
	chomp($data = &backticks($curl,
			'/dev/null', undef, $url, $postdata,
			$no_auth, @wund));
	return &genericnetworkjson($data, $url, $no_auth);
}

sub genericnetworkjson {
	my $data = shift;
	my $url = shift;
	my $no_auth = shift;
	my $my_json_ref = undef; # durrr hat go on foot
	my $i;
	my $tdata;
	my $seed;

	my $k = $? >> 8;
	$data =~ s/[\r\l\n\s]*$//s;
	$data =~ s/^[\r\l\n\s]*//s;

	if (!length($data) || $k == 28 || $k == 7 || $k == 35) {
		&exception(1, "*** warning: timeout or no data\n");
		return undef;
	}

	if ($k > 0) {
		&exception(4,
"*** warning: unexpected error code ($k) from user agent\n");
		return undef;
	}

	# handle things like 304, or other things that look like HTTP
	# error codes
	if ($data =~ m#^HTTP/\d\.\d\s+(\d+)\s+#) {
		$code = 0+$1;
		print $stdout $data if ($superverbose);

		# 304 is actually a cop-out code and is not usually
		# returned, so we should consider it a non-fatal error
		if ($code == 304 || $code == 200 || $code == 204) {
			&exception(1, "*** warning: timeout or no data\n");
			return undef;
		}
		&exception(4,
"*** warning: unexpected HTTP return code $code from server\n");
		return undef;
	}

	$my_json_ref = &parsejson($data);
	$laststatus = 0;
	return $my_json_ref;
}

$keyf = ($keyf =~ m#^/#) ? $keyf : "$ENV{'HOME'}/.hueplkey${keyf}" ;
$comm = shift @ARGV;
if (open(W, "$keyf")) {
	chomp($j = scalar(<W>));
	($ip, $uname) = split(/\s+/, $j);
	$silent = 1 unless ($verbose || $superverbose);
}
if (!length($ip) || !length($uname)) {
	$silent = 0;
	if ($comm ne 'help') {
	print STDOUT "keyfile $keyf could not be opened, starting wizard.\n";
		$comm = "rekey";
	}
}
$retries = 2 if (!defined($retries)); # zero is valid
$comm ||= "help";
$curl ||= &wherecheck("checking for cURL", "curl", <<"EOF");

cURL is required for huepl. if cURL is not usually in your path, you can
hardcode it with -curl=/path/to/curl

EOF

eval "&op_${comm}; exit";
print STDOUT "huepl: unknown command: $comm\n";
print STDOUT "use the help command for help\n";
&iexit(1);

sub op_help {
	print STDOUT <<"EOF";
huepl $VERSION
(c)2016 cameron kaiser and contributors -- all rights reserved
http://www.floodgap.com/software/huepl/

usage: $0 command args...
command can be:

help	this
rekey	generate keyfile (base station must be physically accessible)
config	displays base station config and whitelist
        -> config key value to set permissible values (most are write-only)
scan	scans for new lights
lights	lists lights
load	loads light settings from a file generated by 'lights' (- for stdin)

for individual lights:
on	tells light # to turn on (specify)
off	tells light # to turn off (specify)
bri	sets brightness of light # to # (0-255)
xy	sets CIE 1931 coordinate of light # colour to [ #, # ] (0 <= x,y <= 1)
hs	sets hue and saturation of light # to [ #, # ] (0-65535, 0-255)
ct	sets colour temperature of light # to # (154-500) (in mireds)
rgb	sets RGB of light # to #,#,# (0-255) (UNDER CONSTRUCTION)
blink	starts light # blinking (specify)
	-> blinkoff to stop, blinkonce for 1x

preset colour commands: blue, red, green, yellow, purple, magenta, orange
preset bulb temperature commands: white, warm

send commands to a set of lights: for light light... do command args...
to ignore errors: for light light... try command args... or onanddo, onandtry

huepl $VERSION
(c)2016 cameron kaiser and contributors -- all rights reserved
http://www.floodgap.com/software/huepl/
huepl is provided to you under the Floodgap Free Software License (FFSL).
EOF
	exit;
}

sub op_rekey {
	$nonce ||= &generate_nonce;
	$md5 ||= &wherecheck("checking for md5", "md5");
	if (!length($md5)) {
		print STDOUT "no md5, using sucky nonce $nonce\n";
	} else {
		if ($use_nonce) {
			print STDOUT "-use_nonce: using sucky nonce $nonce\n";
		} else {
			$hostname = &wherecheck("checking for hostname",
				"hostname", <<EOF);

you need hostname to use an md5 hash of (surprise!) your hostname.
if you don't want to do that, specify -use_nonce for a random nonce, or
-nonce=[32 character hash] to force using a particular hash.

EOF
			chomp($nonce = `$hostname | $md5`);
			print STDOUT "hashing hostname to $nonce\n";
	print STDOUT "(to use a random sucky nonce, restart with -use_nonce)\n";
				
		}
	}
	print STDOUT "\ndo NOT press link button yet!!!\n";
	print STDOUT "enter hostname or IP of your hue base: ";
	chomp($j = <STDIN>);
	if (!length($j)) {
		print STDOUT "aborted.\n";
		exit;
	}
	$apiattempt = 0;
	$apistring = <<"EOF";
{ "devicetype" : "HuePl" , "username" : "$nonce" }
EOF
TESTAPI: $ref = &postjson("http://$j/api",  $apistring);
	# we should get back an error 101
	if (ref($ref) ne 'ARRAY' ||
		ref($ref->[0]) ne 'HASH' ||
		ref($ref->[0]->{'error'}) ne 'HASH') {
			print STDOUT "malformed response from hue\n";
			print STDOUT "run with -superverbose to debug\n";
			exit;
	}
	$k = $ref->[0]->{'error'}->{'type'};
	if ($k eq '6' && !$apiattempt) {
		# newer firmwares don't allow username to be specified.
		# try again.
		$apiattempt = 1;
		$apistring = <<"EOF";
{ "devicetype" : "HuePl" }
EOF
		goto TESTAPI;
	}
	if ($k ne '101') {
		print STDOUT "unexpected response from hue: $k\n";
		print STDOUT "run with -superverbose to debug\n";
		exit;
	}
	if(!open(W, ">$keyf") ) {
		print STDOUT "can't write keyfile $keyf: $!\n";
		exit;
	}
	print STDOUT "hue appears to be up\n";
	YOUSCREWEDUP: while(1) {
		print STDOUT "now press link button, and hit RETURN/ENTER: ";
		chomp($k = <STDIN>);
		$ref = &postjson("http://$j/api",  $apistring);
		# now it should work
		if (ref($ref) ne 'ARRAY' ||
			ref($ref->[0]) ne 'HASH') {
			print STDOUT "hue is not responding correctly\n";
			print STDOUT "run with -superverbose to debug\n";
			exit 1;
		}
		if (ref($ref->[0]->{'success'}) eq 'HASH') {
			print STDOUT "hue has accepted authentication\n";
			print W "$j $ref->[0]->{'success'}->{'username'}\n";
			close(W);
			print STDOUT "keyfile written: $keyf\n";
			exit;
		}
		$k = $ref->[0]->{'error'}->{'type'};
		if ($k eq '101') {
			print STDOUT "link button wasn't pushed\n";
			next YOUSCREWEDUP;
		}
		print STDOUT "unexpected response from hue: $k\n";
		print STDOUT "run with -superverbose to debug\n";
		exit 1;
	}
}

sub huejson {
	my $call = shift;
	my $tries = $retries;
	my $wtries = $tries - 1;
	my $ref = undef;
	while($tries-- && !defined($ref)) {
		print STDOUT "temporary failure, retrying\n"
			if (($verbose) && $tries < $wtries);
		$ref = &$call(@_); }
	
	if (!defined($ref)) {
		print STDOUT "unable to communicate with $ip\n";
		print STDOUT "-verbose or -superverbose to diagnose\n";
		&iexit(1);
	}
	if (ref($ref) ne 'HASH') {
		if (ref($ref) eq 'ARRAY') {
			return $ref if (ref($ref->[0]->{'success'}) eq 'HASH');
			$k = $ref->[0]->{'error'}->{'type'};
			print STDOUT "error from hue: $k ".
				$ref->[0]->{'error'}->{'description'} ."\n";
	print STDOUT "if you need to redo authentication, 'huepl rekey'\n"
				if ($k == 1 || $k == 101);
			&iexit(1);
		}
		print STDOUT "unexpected response from hue\n";
		print STDOUT "-verbose or -superverbose to diagnose\n";
		&iexit(1);
	}
	return $ref;
}

sub colourof {
	my $light_ref = shift;
	my $colourmode = $light_ref->{'colormode'};
	if ($colourmode eq 'ct') {
		return "$colourmode $light_ref->{$colourmode}";
	}
	if ($colourmode eq 'xy') {
		return "xy $light_ref->{'xy'}->[0] $light_ref->{'xy'}->[1]";
	}
	if ($colourmode eq 'hs') {
		return "hs $light_ref->{'hue'} $light_ref->{'sat'}";
	}
	if ($colourmode eq '') {
		return "no none";
	}
	return "(huepl does not support \"$colourmode\")";
}
sub colourmode { my $w = shift; return ($w eq '') ? 'no' : $w; } 
sub op_lights {
	$ref = &huejson(\&grabjson, "http://$ip/api/$uname");
	$light_ref = $ref->{'lights'};
	if (!defined($light_ref)) {
		print STDOUT "no lights defined?\n";
		&iexit(1);
	}
	@lights = keys(%{ $light_ref });
	if (!scalar(@lights)) {
		print STDOUT "no lights defined?\n";
		&iexit(1);
	}
	format LIGHTS =
light @<<<  on @<<<<    bri @<<< colormode @<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_, $light_ref->{$_}->{'state'}->{'on'}, $light_ref->{$_}->{'state'}->{'bri'}, &colourmode($light_ref->{$_}->{'state'}->{'colormode'}), &colourof($light_ref->{$_}->{'state'})
.
	$~ = "LIGHTS"; foreach(sort @lights) { write; }
}

sub whichlight {
	return $do if ($do);
	my $light = shift @ARGV;
	if (!length($light)) {
		print STDOUT "$comm requires a light argument\n";
		&iexit(1);
	}
	return $light;
}

sub dowhat {
	my $light = shift;
	my $comm = shift;
	my $arg = shift;	
	&huejson(\&putjson, "http://$ip/api/$uname/lights/$light/state",
		<<"EOF");
{ "$comm": $arg }
EOF
}

sub huesat {
	my $light = shift;
	my $hue = shift;
	my $sat = shift;
	&huejson(\&putjson, "http://$ip/api/$uname/lights/$light/state",
		<<"EOF");
{ "hue": $hue, "sat": $sat }
EOF
}

sub op_bri {
	$light = &whichlight;
	$bri = shift @ARGV;
	if (!length($bri)) {
		print STDOUT "bri needs an argument 0-254\n";
		&iexit(1);
	}
	if ($bri =~ /[^0-9]/) {
		print STDOUT "nonsense brightness: $bri\n";
		&iexit(1);
	}
	if ($bri < 0 || $bri > 255) {
		print STDOUT "brightness range is 0-255\n";
		&iexit(1);
	}
	&dowhat($light, "bri", $bri);
}
sub op_on  { &dowhat(&whichlight, "on", "true");  }
sub op_off { &dowhat(&whichlight, "on", "false"); }

sub op_ct {
	$light = &whichlight;
	$ct = shift @ARGV;
	if (!length($ct)) {
		print STDOUT "ct needs an argument 154-500\n";
		&iexit(1);
	}
	if ($ct =~ /[^0-9]/) {
		print STDOUT "nonsense colour temperature: $ct\n";
		&iexit(1);
	}
	if ($ct < 154 || $bri > 500) {
		print STDOUT "colour temperature range is 154-500\n";
		&iexit(1);
	}
	&dowhat($light, "ct", $ct);
}

sub op_xy {
	$light = &whichlight;
	$x = shift @ARGV;
	if (!length($x)) {
		print STDOUT "xy needs two floating point args 0 <= x,y <= 1\n";
		&iexit(1);
	}
	if ($x =~ /[^.0-9]/) {
		print STDOUT "nonsense coordinate: $x\n";
		&iexit(1);
	}
	if ($x <0 || $x > 1) {
		print STDOUT "coordinate range is 0 <= x,y <= 1\n";
		&iexit(1);
	}
	$y = shift @ARGV;
	if (!length($y)) {
		print STDOUT "xy needs two floating point args 0 <= x,y <= 1\n";
		&iexit(1);
	}
	if ($y =~ /[^.0-9]/) {
		print STDOUT "nonsense coordinate: $y\n";
		&iexit(1);
	}
	if ($y <0 || $y > 1) {
		print STDOUT "coordinate range is 0 <= x,y <= 1\n";
		&iexit(1);
	}
	&dowhat($light, "xy", "[ $x, $y ]");
}

sub op_hs {
	$light = &whichlight;
	$hue = shift @ARGV;
	if (!length($hue)) {
		print STDOUT "hs needs a hue and saturation\n";
		&iexit(1);
	}
	if ($hue =~ /[^0-9]/) {
		print STDOUT "nonsense hue: $hue\n";
		&iexit(1);
	}
	if ($hue < 0 || $hue > 65535) {
		print STDOUT "hue range is 0-65535\n";
		&iexit(1);
	}
	$sat = shift @ARGV;
	if (!length($sat)) {
		print STDOUT "hs needs a hue and saturation\n";
		&iexit(1);
	}
	if ($sat =~ /[^0-9]/) {
		print STDOUT "nonsense saturation: $sat\n";
		&iexit(1);
	}
	if ($sat < 0 || $sat > 255) {
		print STDOUT "saturation range is 0-255\n";
		&iexit(1);
	}
	&huesat($light, $hue, $sat);
}

sub op_rgb {
	$light = &whichlight;
	for $k (0..2) {
		$rgb[$k] = shift @ARGV;
		if (!length($rgb[$k])) {
			print STDOUT "rgb needs red, green, blue values\n";
			&iexit(1);
		}
		if ($rgb[$k] =~ /[^0-9]/) {
			print STDOUT "nonsense rgb value: $rgb[$k]\n";
			&iexit(1);
		}
		if ($rgb[$k] < 0 || $rgb[$k] > 255) {
			print STDOUT "rgb range is 0-255\n";
			&iexit(1);
		}
	}
	$r = $rgb[0]; $g = $rgb[1]; $b = $rgb[2];
	if ($use_cie) {
		# inverse matrix convolution; tip of the hat to
		# https://gist.github.com/30c50aa4b161f8169c3d
		# this is now deprecated due to poor peak responses
		$r = $r/255; $g = $g/255; $b = $b/255; $w = $r+$g+$b;

		# |R|   | X |   | 3.2333 -1.5262 0.2791 |
		# |G| = | Y | * |-0.8268  2.4667 0.3323 |
		# |B|   | Z |   | 0.1294  0.1983 2.0280 |
		# inverse matrix is
		# |X| = | R |   |  0.3739  0.2386 -0.0906 | 
		# |Y| = | G | * |  0.1303  0.4940 -0.0989 |
		# |Z| = | B |   | -0.0366 -0.0635  0.5085 |

		$x = ($r * 0.3739) + ($g * 0.2386) + ($b * -0.0906);
		$y = ($r * 0.1303) + ($g * 0.4940) + ($b * -0.0989);
		$x = 0 if ($x < 0);
		$y = 0 if ($y < 0);
		&dowhat($light, "xy", "[ $x, $y ]");
	} else {
		# default: use hs
		my ($h, $s, $l) = &rgbtohsl($r, $g, $b);
		&huesat($light, $h, $s);
		&dowhat($light, "bri", $l);
	}
}

# presets

sub op_white   { &huesat(&whichlight, 0, 0); }
sub op_red     { &huesat(&whichlight, 0, 255); }
sub op_orange  { &huesat(&whichlight, 4096, 255); }
sub op_yellow  { &huesat(&whichlight, 16384, 255); }
sub op_green   { &huesat(&whichlight, 25600, 255); }
sub op_blue    { &huesat(&whichlight, 47000, 255); }
sub op_purple  { &huesat(&whichlight, 49408, 255); }
sub op_magenta { &huesat(&whichlight, 57344, 255); }
sub op_warm    { &dowhat(&whichlight, "ct", 340); }

# blinkers

sub op_blink     { &dowhat(&whichlight, "alert", '"lselect"'); }
sub op_blinkoff  { &dowhat(&whichlight, "alert", '"none"'); }
sub op_blinkonce { &dowhat(&whichlight, "alert", '"select"'); }

# scripting

sub op_for {
	$on_mode = 0;
	while($p = shift(@ARGV)) {
		$exit_mode = 1 if ($p eq 'try' || $p eq 'onandtry');
		$on_mode = 1 if ($p eq 'onanddo' || $p eq 'onandtry');
		last if ($p eq 'do' || $p eq 'try' || $p eq 'onanddo' ||
				$p eq 'onandtry');
		push(@lights, $p);
	}
	if (!scalar(@ARGV)) {
		print STDOUT "usage: for light light... (do|try|onanddo|onandtry) comm arg...\n";
		exit 1;
	}
	$comm = shift(@ARGV);
	if ($comm eq 'scan' || $comm eq 'rekey' || $comm eq 'help' ||
		$comm eq 'load' || $comm eq 'config') {
		print STDOUT "command $comm not supported in for/$p\n";
		exit 1;
	}
	@k = @ARGV;
	foreach $do (@lights) {
		print STDOUT "$comm $do @k\n" if ($verbose);
		if ($on_mode) { @ARGV = @k; &op_on; }
		@ARGV = @k;
		eval "&op_${comm}; return 1;" || die("bad verb: $comm\n");
	}
}

# adding lights

sub op_scan {
	$ref = &huejson(\&postjson, "http://$ip/api/$uname/lights", "");
	print STDOUT "scan status: " .
		$ref->[0]->{'success'}->{'/lights'} . "\n";
	print STDOUT "this may take a few minutes; 'huepl lights' for result\n";
}

# generic

sub op_config {
	if (scalar(@ARGV)) {
		$key = shift @ARGV;
		$value = join(" ", @ARGV);
		$value = ($value eq 'true' || $value eq 'false') ? $value
			: ($value =~ /^[0-9]+$/) ? $value
			: "\"$value\"";
		$ref = &huejson(\&putjson, "http://$ip/api/$uname/config",
			<<"EOF");
{ "$key": $value }
EOF
	}
	$ref = &huejson(\&grabjson, "http://$ip/api/$uname");	
	$ref = $ref->{'config'};
	if (!defined($ref) || ref($ref) ne 'HASH') {
		print STDOUT "failed to get config from base station\n";
		print STDOUT "-verbose or -superverbose to diagnose\n";
		&iexit(1);
	}
	@keys = keys(%{ $ref });
	format CONFIG =
@<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_, $ref->{$_}
.
	$~ = "CONFIG";
	foreach (sort @keys) {
		next if (length(ref($ref->{$_})));
		write;
	}

	print STDOUT "\n\nwhitelist\n---------\n";
	$ref = $ref->{'whitelist'}; # this MUST exist if we connected!
	@keys = keys(%{ $ref });
	format WHITELIST =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_, $ref->{$_}->{'name'}
.
	$~ = "WHITELIST"; foreach(sort @keys) { write; }
}

sub op_load {
	$f = shift(@ARGV);
	if (!length($f)) {
		print STDOUT "load requires a filename (or - for stdin)\n";
		&iexit(1);
	}
	if ($f eq '-') {
		open(L, "<&STDIN") || die("couldn't dup stdin: $!\n");
	} else {
		if (!open(L,$f)) {
			print STDOUT "couldn't open file $f: $!\n";
			&iexit(1);
		}
	}
	$ref = &huejson(\&grabjson, "http://$ip/api/$uname");
       	$light_ref = $ref->{'lights'};
	if (!defined($light_ref)) {
		print STDOUT "no lights defined?\n";
		exit 1;
	}
	@lights = keys(%{ $light_ref });
	if (!scalar(@lights)) {
		print STDOUT "no lights defined?\n";
		exit 1;
	}
	while(<L>) {
		print if ($verbose);
		chomp;
		next if (/^#/ || !length);
if (/^light ([^\s]+)\s+on\s(true|false)\s+bri\s+([0-9]+)\s+colormode\s+[^\s]+\s+([^\s]+)\s+(.+)$/) {
			$do = $1;
			$on_off = $2;
			$bri = $3;
			$colourmode = $4;
			$colourargs = $5;

			$this_light = $light_ref->{$do};
			# check if on/off status matches
			if ($this_light->{'state'}->{'on'} ne $on_off) {
				if ($on_off eq 'false') { &op_off; }
				else { &op_on; }
			}
			next if ($on_off eq 'false'); # nothing more to do

			# set parameters
			&dowhat($do, "bri", $bri);
			next if ($colourmode eq 'no'); # dummy mode
			if ($colourmode eq 'ct') {
				&dowhat($do, "ct", $colourargs);
				next;
			}
			($one, $two) = split(/\s+/, $colourargs);
			if ($colourmode eq 'xy') {
				&dowhat($do, "xy", "[ $one, $two ]");
				next;
			}
			if ($colourmode ne 'hs') {
				print STDOUT "unknown colour model in state: $_\n";
				&iexit(1);
			}
			&huesat($do, $one, $two);
		} else {
			print STDOUT "unexpected line in state: $_\n";
			&iexit(1);
		}
	}
	close(L);
	&iexit(0);
}

sub rgbtohsl {
	# modified from http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript
	my $r = shift;
	my $g = shift;
	my $b = shift;
	my $fi = &max($r, $g, $b);

	$r /= 255; $g /= 255; $b /= 255;
	my $max = &max($r, $g, $b);
	my $min = &min($r, $g, $b);
	my $i = ($max + $min) /2;
	my $h = $i;
	my $s = $i;
	my $l = $i;

	if($max == $min) {
		$h = $s = 0; # no chroma
	} else {
		my $d = $max - $min;
		$s = ($l > 0.5) ? ($d / (2 - $max - $min)) :
			($d / ($max + $min));
		if ($max == $r) {
			$h = ($g - $b) / $d + (($g < $b) ? 6 : 0);
		} elsif ($max == $g) {
			$h = ($b - $r) / $d + 2;
		} elsif ($max == $b) {
			$h = ($r - $g) / $d + 4;
		}
		$h /= 6;
	}

	$l = $fi;
	$s *= 255;
	$h *= 65535;

	# massage h, which has a non-linear response, to as close to colour
	# fidelity as possible. note that this fails for cyan, which comes
	# out somewhat like white.
	$h +=	($h < 10923) ? (5462*($h/10923)) :
		($h < 21846) ? (3755*($h/21845)) :
		($h < 43691) ? (3414*($h/43691)) :
		($h < 54613) ? (-5204*($h/54613)) :
		($h < 59368) ? (-2023*($h/59368)) :
		0;

	return (int($h), int($s), int($l));
}

sub max {
	my ($x, $y, $z) = (@_);
	return (($x > $y) && ($x > $z)) ? $x :
		($y > $z) ? $y :
		$z;
}

sub min {
	my ($x, $y, $z) = (@_);
	return (($x < $y) && ($x < $z)) ? $x :
		($y < $z) ? $y :
		$z;
}

