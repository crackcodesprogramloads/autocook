BEGIN;

-- Plan the number of tests (1 for policies_are)
SELECT plan(1);

-- Test RLS policies on the recipes table
SELECT policies_are(
    'recipes',
    ARRAY[
        'Enable delete access for users on their own recipes',
        'Enable insert access for users on their own recipes',
        'Enable read access for users on their own recipes',
        'Enable update access for users on their own recipes'
    ],
    'RLS policies on recipes table should match expected'
);

-- Finish the test
SELECT finish();

ROLLBACK;

