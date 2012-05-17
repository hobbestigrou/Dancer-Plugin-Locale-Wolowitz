package Dancer::Plugin::Locale::Wolowitz;

use strict;
use warnings;

use 5.10.2;

use Dancer ':syntax';
use Dancer::Plugin;

use Locale::Wolowitz;

#ABSTRACT: Intenationalization for Dancer

my $w = Locale::Wolowitz->new(_path_directory_locale());

add_hook(
    before_template => sub {
        my $tokens = shift;

        $tokens->{l} = sub { _loc(@_); };
    }
);

register loc => sub {
    _loc(@_);
};

sub _loc {
    my ( $str, $args ) = @_;

    my $lang = _lang();

    !$args and return $w->loc($str, $lang);

    my $msg = $w->loc($str, $lang, map($w->loc($_, $lang), @{$args}));

    return $msg;
}

sub _path_directory_locale {
    my $settings = plugin_setting;
    my $path     = $settings->{locale_path_directory} // Dancer::FileUtils::path(
        setting('appdir'), 'i18n'
    );

    return $path;
}

sub _lang {
    my $settings     = plugin_setting;
    my $lang_session = $settings->{lang_session} // 'lang';
    my $lang         = session($lang_session);

    if ( ! $lang ) {
        $lang = request->accept_language;
        $lang =~ s/-\w+//g;
        session $lang_session => $lang;
    }

    return $lang;
}

1;
