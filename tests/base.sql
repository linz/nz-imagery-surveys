------------------------------------------------------------------------------
-- Provide unit testing for imagery surveys using pgTAP
------------------------------------------------------------------------------

-- Turn off echo.
\set QUIET 1

-- Format the output nicely.
\pset format unaligned
\pset tuples_only true
\pset pager

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true


BEGIN;

SELECT plan(1);

-- Tests
SELECT has_schema('aerial');
SELECT has_table('aerial', 'imagery_surveys', 'Should have imagery surveys table in the aerial schema');

-- Finish pgTAP testing
SELECT * FROM finish();

ROLLBACK;
