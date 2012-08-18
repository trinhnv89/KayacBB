use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Kayac::Forum';
use Kayac::Forum::Controller::Search;

ok( request('/search')->is_success, 'Request should succeed' );
done_testing();
