use utf8;
package Kayac::Forum::Schema::ForumDB::Result::Access;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::Access

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

=head1 TABLE: C<access>

=cut

__PACKAGE__->table("access");

=head1 ACCESSORS

=head2 access_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 topic_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 permission_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "access_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "role_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "topic_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "permission_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</access_id>

=back

=cut

__PACKAGE__->set_primary_key("access_id");

=head1 RELATIONS

=head2 permission

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Permission>

=cut

__PACKAGE__->belongs_to(
  "permission",
  "Kayac::Forum::Schema::ForumDB::Result::Permission",
  { permission_id => "permission_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 role

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Kayac::Forum::Schema::ForumDB::Result::Role",
  { role_id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 topic

Type: belongs_to

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Topic>

=cut

__PACKAGE__->belongs_to(
  "topic",
  "Kayac::Forum::Schema::ForumDB::Result::Topic",
  { topic_id => "topic_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-26 23:33:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HcnTVrsmkfkNQhkHeZRpUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
