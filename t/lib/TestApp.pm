package t::lib::TestApp;

use Dancer;
use Dancer::Plugin::Locale::Wolowitz;

get '/' => sub {
    my $tr = loc('welcome');
    return $tr;
};

get '/no_key' => sub {
    my $tr = loc('goodbye');
    return $tr;
};

get '/complex_key' => sub {
    my $path = setting('appdir');
    my $tr   = loc('path_not_found %1', [$path]);

    return $tr;
};

get '/twice_same_request' => sub {
    return loc("welcome") .' '. loc("hello");
};

1;
