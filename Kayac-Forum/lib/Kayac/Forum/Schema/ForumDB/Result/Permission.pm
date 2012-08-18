use utf8;
package Kayac::Forum::Schema::ForumDB::Result::Permission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Kayac::Forum::Schema::ForumDB::Result::Permission

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

=head1 TABLE: C<permission>

=cut

__PACKAGE__->table("permission");

=head1 ACCESSORS

=head2 permission_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 permission_name

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "permission_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "permission_name",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</permission_id>

=back

=cut

__PACKAGE__->set_primary_key("permission_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<permission_name>

=over 4

=item * L</permission_name>

=back

=cut

__PACKAGE__->add_unique_constraint("permission_name", ["permission_name"]);

=head1 RELATIONS

=head2 accesses

Type: has_many

Related object: L<Kayac::Forum::Schema::ForumDB::Result::Access>

=cut

__PACKAGE__->has_many(
  "accesses",
  "Kayac::Forum::Schema::ForumDB::Result::Access",
  { "foreign.permission_id" => "self.permission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-26 23:33:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BQKsbIzCzSS4qmelq1XfPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
