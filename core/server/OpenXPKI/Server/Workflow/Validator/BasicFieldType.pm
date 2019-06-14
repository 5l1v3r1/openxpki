package OpenXPKI::Server::Workflow::Validator::BasicFieldType;

use strict;
use warnings;
use Moose;
use Workflow::Exception qw( validation_error );
use OpenXPKI::Debug;
use Data::Dumper;
use OpenXPKI::Server::Context qw( CTX );

extends 'OpenXPKI::Server::Workflow::Validator';

sub _validate {

    my ( $self, $wf, @fields ) = @_;

    ##! 1: 'start - type ' .$type

    ##! 16: 'Fields ' . Dumper \@fields
    my $context  = $wf->context;
    my @no_value = ();
    foreach my $key (@fields) {

        my ($field, $type, $is_array, $is_required) = split /:/, $key;

        if ($is_required && !defined $context->param($field) ) {
            ##! 32: 'undefined ' . $field
            push @no_value, $field;
            next;
        }

        if ($is_array && ref $context->param($field) ne 'ARRAY') {
            ##! 32: 'not array ' . $field
            push @no_value, $field;
            next;
        }

        # ignore deep checks on refs for now
        if ( ref $context->param($field) ) {
            ##! 32: 'found ref - skipping ' . $field
            next;
        }

        # check for empty string
        if ( $context->param($field) eq '' ) {
            ##! 32: 'empty string ' . $field
            push @no_value, $field;
            next;
        }

    }

    if ( scalar @no_value ) {
        ##! 16: 'Found ' . Dumper \@no_value
        validation_error ('I18N_OPENXPKI_UI_VALIDATOR_FIELD_TYPE_INVALID', { invalid_fields => \@no_value });
    }
}

1;

__END__

=head1 NAME

OpenXPKI::Server::Workflow::Validator::BasicFieldType;

=head1 DESCRIPTION

This validator should not be added by manual configuration. It replaces
the HasRequiredField Validator from the upstream packages and is added by
OpenXPKI::Workflow::Config based on the required and type settings in the
workflows field configuration.
