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

=method loc

    loc('Welcome');
or
    <% l('Welcome') %>

Translated to the requested language, if such a translation exists, otherwise no traslation occurs.

    input: (Str): Key translate
           (Arrayref): Arguments are injected to the placeholders in the string
    output: (Str): Translated to the requested language

=cut

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

=encoding UTF-8

=head1 SYNOPSIS

    use Dancer ':syntax';
    use Dancer::Plugin::Locale::Wolowitz;

    get '/' => sub {
        template index;
    }

=head1 CONFIGURATION

  plugins:
    Locale::Wolowitz:
      lang_session: "lang"
      locale_path_directory: "i18n"

=head1 CONTRIBUTING

This module is developed on Github at:

L<http://github.com/hobbestigrou/Dancer-Plugin-Locale-Wolowitz>

=head1 ACKNOWLEDGEMENTS

Thanks to Ido Perlmuter

=head1 BUGS

Please report any bugs or feature requests in github.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dancer::Plugin::Locale::Wolowitz

=head1 SEE ALSO

L<Dancer>

=cut
