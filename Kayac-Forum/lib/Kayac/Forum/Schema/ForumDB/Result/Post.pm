use utf8;
use DateTime;
package Kayac::Forum::Schema::ForumDB::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::Post

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<post>

=cut

__PACKAGE__->table("post");

=head1 ACCESSORS

=head2 post_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 post_thread_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 post_body

  data_type: 'longtext'
  is_nullable: 0

=head2 post_created_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 post_last_modified

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 post_owner

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "post_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "post_thread_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "post_body",
  { data_type => "longtext", is_nullable => 0 },
  "post_created_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "post_last_modified",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "post_owner",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_id>

=back

=cut

__PACKAGE__->set_primary_key("post_id");

=head1 RELATIONS

=head2 post_owner

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::User>

=cut

__PACKAGE__->belongs_to(
  "post_owner",
  "Kayac::Forum::Schema::ForumDB::Result::User",
  { user_id => "post_owner" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 post_thread

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Thread>

=cut

__PACKAGE__->belongs_to(
  "post_thread",
  "Kayac::Forum::Schema::ForumDB::Result::Thread",
  { thread_id => "post_thread_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-06 21:39:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jxLv8EzlB8BdJmaZanOXkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;

sub print_created_date {
    my ($self) = @_;
    
    #my $dt = DateTime->new($self->post_created_date);
    
    #my $time = sprintf("%2d/%2d/%4d %2d::%2d", $dt->day, $dt->month, $dt->year, $dt->hour, $dt->minute);
    #my $time_str = strftime "%a %b %e %H:%M:%S %Y", $self->post_created_date;
    return $self->post_created_date;
}

1;
