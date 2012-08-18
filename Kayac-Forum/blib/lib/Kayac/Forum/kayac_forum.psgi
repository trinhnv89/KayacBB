use strict;
use warnings;

use Kayac::Forum;

my $app = Kayac::Forum->apply_default_middlewares(Kayac::Forum->psgi_app);
$app;

