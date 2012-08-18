use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Kayac::Forum';
use Kayac::Forum::Controller::View;

ok( request('/view')->is_success, 'Request should succeed' );
done_testing();
