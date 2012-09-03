use strict;
use warnings;

use Test::More import => ['!pass'];

use Dancer;
use Dancer::Test;

use lib 't/lib';
use TestApp;

plan tests => 7;

setting appdir => setting('appdir') . '/t';

session lang => 'en';
my $res = dancer_response GET => '/';
is $res->{status}, 200, 'check status response';
is $res->{content}, 'Welcome', 'check simple key english';

$res = dancer_response GET => '/no_key';
is $res->{content}, 'hello', 'check no key found english';

$res     = dancer_response GET => '/complex_key';
my $path = setting('appdir');
is $res->{content},  "$path not found", 'check complex key english';

session lang => 'fr';
$res = dancer_response GET => '/';
is $res->{content}, 'Bienvenue', 'check simple key french';

$res = dancer_response GET => '/no_key';
is $res->{content}, 'hello', 'check no key found french';

$res = dancer_response GET => '/complex_key';
is $res->{content}, "Repertoire $path non trouve", 'check complex key english';
